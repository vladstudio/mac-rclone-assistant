import Foundation

// MARK: - Shell (outside @MainActor to avoid deadlocks)

enum Shell {
    static func run(executable: String, arguments: [String]) async throws -> String {
        try await Task.detached {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments

            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError = stderr
            process.standardInput = FileHandle.nullDevice

            try process.run()

            // Read pipe data BEFORE waitUntilExit to avoid deadlock
            // when output exceeds the pipe buffer (~64KB)
            let outData = stdout.fileHandleForReading.readDataToEndOfFile()
            let errData = stderr.fileHandleForReading.readDataToEndOfFile()

            process.waitUntilExit()

            if process.terminationStatus != 0 {
                let errStr = String(data: errData, encoding: .utf8) ?? "Unknown error"
                throw RcloneError.commandFailed(errStr)
            }

            return String(data: outData, encoding: .utf8) ?? ""
        }.value
    }

    static func findExecutable(candidates: [String]) -> String? {
        candidates.first { FileManager.default.isExecutableFile(atPath: $0) }
    }
}

// MARK: - Log

struct LogEntry: Identifiable {
    let id = UUID()
    let date: Date
    let command: String
    let output: String
    let isError: Bool
}

private let maxLogEntries = 200

private let sensitiveKeys: Set<String> = [
    "token", "client_secret", "password", "pass", "key", "secret",
    "client_id", "access_key_id", "secret_access_key",
]

/// Redact sensitive values from a command string for logging
private func redactCommand(_ arguments: [String]) -> String {
    var parts: [String] = []
    var redactNext = false
    for arg in arguments {
        if redactNext {
            parts.append("***")
            redactNext = false
            continue
        }
        if arg.contains("=") {
            let key = String(arg.prefix(while: { $0 != "=" }))
            if sensitiveKeys.contains(key) {
                parts.append("\(key)=***")
                continue
            }
        }
        // Check if this arg is a key that the next arg is its value
        if sensitiveKeys.contains(arg) {
            redactNext = true
        }
        // Quote args with spaces for readability
        if arg.contains(" ") {
            parts.append("\"\(arg)\"")
        } else {
            parts.append(arg)
        }
    }
    return "rclone " + parts.joined(separator: " ")
}

// MARK: - Service

@MainActor
final class RcloneService: ObservableObject {
    @Published var rclonePath: String?
    @Published var remotes: [RemoteConfig] = []
    @Published var providers: [ProviderDefinition] = []
    @Published var log: [LogEntry] = []

    /// Provider name → description lookup for O(1) access
    var providerDescriptions: [String: String] = [:]

    init() {
        rclonePath = Shell.findExecutable(candidates: [
            "/opt/homebrew/bin/rclone",
            "/usr/local/bin/rclone",
            "/usr/bin/rclone",
        ])
    }

    var isInstalled: Bool { rclonePath != nil }

    func refreshPath() {
        rclonePath = Shell.findExecutable(candidates: [
            "/opt/homebrew/bin/rclone",
            "/usr/local/bin/rclone",
            "/usr/bin/rclone",
        ])
    }

    func loadRemotes() async throws {
        let output = try await rclone(["config", "dump"])
        guard let data = output.data(using: .utf8) else { return }
        let dump = try JSONDecoder().decode([String: [String: String]].self, from: data)
        remotes = RemoteConfig.fromDump(dump)
    }

    func loadProvidersIfNeeded() async throws {
        guard providers.isEmpty else { return }
        let output = try await rclone(["config", "providers"])
        guard let data = output.data(using: .utf8) else { return }
        let all = try JSONDecoder().decode([ProviderDefinition].self, from: data)
        providers = all.filter { !$0.hide }
        providerDescriptions = Dictionary(uniqueKeysWithValues: providers.map { ($0.name, $0.description) })
    }

    func createRemote(name: String, type: String, params: [String: String]) async throws {
        _ = try await rclone(["config", "create", name, type] + encodeParams(params))
    }

    func updateRemote(name: String, params: [String: String]) async throws {
        _ = try await rclone(["config", "update", name] + encodeParams(params))
    }

    func deleteRemote(name: String) async throws {
        _ = try await rclone(["config", "delete", name])
    }

    /// Atomic rename: create new first, only delete old on success
    func renameRemote(oldName: String, newName: String, params: [String: String], type: String) async throws {
        try await createRemote(name: newName, type: type, params: params)
        try await deleteRemote(name: oldName)
    }

    func authorize(backend: String, params: [String: String] = [:]) async throws -> String {
        var args = ["authorize", backend]
        if let clientId = params["client_id"], !clientId.isEmpty,
           let clientSecret = params["client_secret"], !clientSecret.isEmpty {
            args.append(clientId)
            args.append(clientSecret)
        }
        return try await rclone(args)
    }

    // MARK: - Private

    private func encodeParams(_ params: [String: String]) -> [String] {
        params.map { "\($0.key)=\($0.value)" }
    }

    private func rclone(_ arguments: [String]) async throws -> String {
        guard let path = rclonePath else {
            throw RcloneError.notInstalled
        }
        let cmd = redactCommand(arguments)
        do {
            let result = try await Shell.run(executable: path, arguments: arguments)
            appendLog(LogEntry(date: Date(), command: cmd, output: result, isError: false))
            return result
        } catch {
            appendLog(LogEntry(date: Date(), command: cmd, output: error.localizedDescription, isError: true))
            throw error
        }
    }

    private func appendLog(_ entry: LogEntry) {
        log.append(entry)
        if log.count > maxLogEntries {
            log.removeFirst(log.count - maxLogEntries)
        }
    }
}

enum RcloneError: LocalizedError {
    case notInstalled
    case commandFailed(String)

    var errorDescription: String? {
        switch self {
        case .notInstalled: "rclone is not installed"
        case .commandFailed(let msg): msg
        }
    }
}

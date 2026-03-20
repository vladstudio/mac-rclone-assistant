import Foundation

// Process runner — fully outside @MainActor to avoid deadlocks
private enum Shell {
    static func run(executable: String, arguments: [String]) async throws -> String {
        try await Task.detached {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: executable)
            process.arguments = arguments

            let stdout = Pipe()
            let stderr = Pipe()
            process.standardOutput = stdout
            process.standardError = stderr
            // Close stdin so rclone never blocks waiting for input
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

    static func findRclone() -> String? {
        let candidates = [
            "/opt/homebrew/bin/rclone",
            "/usr/local/bin/rclone",
            "/usr/bin/rclone",
        ]
        for path in candidates {
            if FileManager.default.isExecutableFile(atPath: path) {
                return path
            }
        }
        return nil
    }
}

@MainActor
final class RcloneService: ObservableObject {
    @Published var rclonePath: String?
    @Published var remotes: [RemoteConfig] = []
    @Published var providers: [ProviderDefinition] = []

    init() {
        rclonePath = Shell.findRclone()
    }

    var isInstalled: Bool { rclonePath != nil }

    func refreshPath() {
        rclonePath = Shell.findRclone()
    }

    // MARK: - List remotes

    func loadRemotes() async throws {
        let output = try await rclone(["config", "dump"])
        guard let data = output.data(using: .utf8) else { return }
        let dump = try JSONDecoder().decode([String: [String: String]].self, from: data)
        remotes = RemoteConfig.fromDump(dump)
    }

    // MARK: - Load providers

    func loadProviders() async throws {
        let output = try await rclone(["config", "providers"])
        guard let data = output.data(using: .utf8) else { return }
        let all = try JSONDecoder().decode([ProviderDefinition].self, from: data)
        providers = all.filter { !$0.hide }
    }

    // MARK: - Create remote

    func createRemote(name: String, type: String, params: [String: String]) async throws {
        var args = ["config", "create", name, type]
        for (key, value) in params where key != "type" {
            args.append("\(key)=\(value)")
        }
        _ = try await rclone(args)
    }

    // MARK: - Update remote

    func updateRemote(name: String, params: [String: String]) async throws {
        var args = ["config", "update", name]
        for (key, value) in params where key != "type" {
            args.append("\(key)=\(value)")
        }
        _ = try await rclone(args)
    }

    // MARK: - Delete remote

    func deleteRemote(name: String) async throws {
        _ = try await rclone(["config", "delete", name])
    }

    // MARK: - Rename remote (delete + create)

    func renameRemote(oldName: String, newName: String) async throws {
        let output = try await rclone(["config", "dump"])
        guard let data = output.data(using: .utf8),
              let dump = try JSONSerialization.jsonObject(with: data) as? [String: [String: String]],
              let params = dump[oldName],
              let type = params["type"]
        else { return }

        var createParams = params
        createParams.removeValue(forKey: "type")

        try await deleteRemote(name: oldName)
        try await createRemote(name: newName, type: type, params: createParams)
    }

    // MARK: - Authorize (OAuth)

    func authorize(backend: String, params: [String: String] = [:]) async throws -> String {
        var args = ["authorize", backend]
        if let clientId = params["client_id"], !clientId.isEmpty,
           let clientSecret = params["client_secret"], !clientSecret.isEmpty {
            args.append(clientId)
            args.append(clientSecret)
        }
        return try await rclone(args)
    }

    // MARK: - Run rclone

    private func rclone(_ arguments: [String]) async throws -> String {
        guard let path = rclonePath else {
            throw RcloneError.notInstalled
        }
        return try await Shell.run(executable: path, arguments: arguments)
    }
}

enum RcloneError: LocalizedError {
    case notInstalled
    case commandFailed(String)

    var errorDescription: String? {
        switch self {
        case .notInstalled:
            "rclone is not installed"
        case .commandFailed(let msg):
            msg
        }
    }
}

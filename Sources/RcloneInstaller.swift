import SwiftUI

struct InstallerView: View {
    @EnvironmentObject var rclone: RcloneService
    @State private var status = "Checking for rclone..."
    @State private var isInstalling = false
    @State private var failed = false

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "externaldrive.badge.questionmark")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("rclone not found")
                .font(.title2.bold())

            Text(status)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if failed {
                Button("Try Again") {
                    Task { await install() }
                }
                .buttonStyle(.borderedProminent)
            }

            if isInstalling {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .padding(40)
        .frame(width: 400)
        .task { await install() }
    }

    private func install() async {
        isInstalling = true
        failed = false

        // Try homebrew first
        status = "Trying brew install rclone..."
        if let brewPath = findBrew() {
            do {
                let result = try runInstallCommand(brewPath, arguments: ["install", "rclone"])
                if result {
                    rclone.refreshPath()
                    if rclone.isInstalled {
                        status = "Installed via Homebrew!"
                        isInstalling = false
                        return
                    }
                }
            } catch {
                // Fall through to zip download
            }
        }

        // Download zip
        status = "Downloading rclone..."
        do {
            let url = URL(string: "https://downloads.rclone.org/rclone-current-osx-arm64.zip")!
            let (fileURL, _) = try await URLSession.shared.download(from: url)
            let tmp = FileManager.default.temporaryDirectory.appendingPathComponent("rclone-install")
            try? FileManager.default.removeItem(at: tmp)
            try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)

            status = "Extracting..."
            let unzip = Process()
            unzip.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
            unzip.arguments = ["-o", fileURL.path, "-d", tmp.path]
            try unzip.run()
            unzip.waitUntilExit()

            // Find the binary inside extracted folder
            let contents = try FileManager.default.contentsOfDirectory(at: tmp, includingPropertiesForKeys: nil)
            guard let rcloneDir = contents.first(where: { $0.lastPathComponent.hasPrefix("rclone-") }) else {
                throw RcloneError.commandFailed("Could not find rclone in extracted archive")
            }
            let binary = rcloneDir.appendingPathComponent("rclone")

            // Copy to /usr/local/bin (may need admin)
            let dest = "/usr/local/bin/rclone"
            status = "Installing to \(dest)..."

            // Try direct copy first
            try? FileManager.default.removeItem(atPath: dest)
            do {
                try FileManager.default.createDirectory(atPath: "/usr/local/bin", withIntermediateDirectories: true)
                try FileManager.default.copyItem(atPath: binary.path, toPath: dest)
                // Make executable
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: dest)
            } catch {
                // Use osascript for admin privileges
                let script = "do shell script \"mkdir -p /usr/local/bin && cp \\\"\(binary.path)\\\" \(dest) && chmod 755 \(dest)\" with administrator privileges"
                let osa = Process()
                osa.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
                osa.arguments = ["-e", script]
                try osa.run()
                osa.waitUntilExit()
                if osa.terminationStatus != 0 {
                    throw RcloneError.commandFailed("Failed to install rclone with admin privileges")
                }
            }

            try? FileManager.default.removeItem(at: tmp)
            rclone.refreshPath()
            if rclone.isInstalled {
                status = "Installed!"
            } else {
                status = "Installation failed. Please install rclone manually."
                failed = true
            }
        } catch {
            status = "Failed: \(error.localizedDescription)"
            failed = true
        }

        isInstalling = false
    }

    private func findBrew() -> String? {
        let candidates = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew"]
        return candidates.first { FileManager.default.isExecutableFile(atPath: $0) }
    }

    private func runInstallCommand(_ executable: String, arguments: [String]) throws -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments
        try process.run()
        process.waitUntilExit()
        return process.terminationStatus == 0
    }
}

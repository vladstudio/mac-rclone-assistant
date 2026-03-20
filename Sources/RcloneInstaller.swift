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

        if await tryBrewInstall() { isInstalling = false; return }
        await tryZipInstall()

        isInstalling = false
    }

    private func tryBrewInstall() async -> Bool {
        guard let brewPath = Shell.findExecutable(candidates: ["/opt/homebrew/bin/brew", "/usr/local/bin/brew"]) else {
            return false
        }
        status = "Trying brew install rclone..."
        do {
            _ = try await Shell.run(executable: brewPath, arguments: ["install", "rclone"])
            rclone.refreshPath()
            if rclone.isInstalled {
                status = "Installed via Homebrew!"
                return true
            }
        } catch {
            // Fall through to zip download
        }
        return false
    }

    private func tryZipInstall() async {
        // Detect architecture for correct download
        let arch = ProcessInfo.processInfo.machineArchitecture
        let zipName = arch == "x86_64" ? "rclone-current-osx-amd64.zip" : "rclone-current-osx-arm64.zip"
        let url = URL(string: "https://downloads.rclone.org/\(zipName)")!

        status = "Downloading rclone..."
        do {
            let (fileURL, _) = try await URLSession.shared.download(from: url)
            let tmp = FileManager.default.temporaryDirectory.appendingPathComponent("rclone-install")
            try? FileManager.default.removeItem(at: tmp)
            try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)

            status = "Extracting..."
            _ = try await Shell.run(executable: "/usr/bin/unzip", arguments: ["-o", fileURL.path, "-d", tmp.path])

            let contents = try FileManager.default.contentsOfDirectory(at: tmp, includingPropertiesForKeys: nil)
            guard let rcloneDir = contents.first(where: { $0.lastPathComponent.hasPrefix("rclone-") }) else {
                throw RcloneError.commandFailed("Could not find rclone in extracted archive")
            }
            let binary = rcloneDir.appendingPathComponent("rclone")
            let dest = "/usr/local/bin/rclone"
            status = "Installing to \(dest)..."

            try? FileManager.default.removeItem(atPath: dest)
            do {
                try FileManager.default.createDirectory(atPath: "/usr/local/bin", withIntermediateDirectories: true)
                try FileManager.default.copyItem(atPath: binary.path, toPath: dest)
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: dest)
            } catch {
                _ = try await Shell.run(executable: "/bin/bash", arguments: [
                    "-c", "mkdir -p /usr/local/bin && cp \"$1\" \"$2\" && chmod 755 \"$2\"",
                    "--", binary.path, dest,
                ])
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
    }
}

extension ProcessInfo {
    var machineArchitecture: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return withUnsafePointer(to: &sysinfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingCString: $0) ?? "arm64"
            }
        }
    }
}

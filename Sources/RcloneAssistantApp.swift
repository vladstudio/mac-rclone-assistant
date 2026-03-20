import SwiftUI

@main
struct RcloneAssistantApp: App {
    @StateObject private var rclone = RcloneService()

    var body: some Scene {
        Window("Rclone Assistant", id: "main") {
            if rclone.isInstalled {
                MainView()
            } else {
                InstallerView()
            }
        }
        .environmentObject(rclone)
        .windowResizability(.contentSize)

        Window("Log", id: "log") {
            LogView()
        }
        .environmentObject(rclone)
        .defaultSize(width: 700, height: 500)
    }
}

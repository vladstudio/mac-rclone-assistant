import SwiftUI

@main
struct RcloneAssistantApp: App {
    @StateObject private var rclone = RcloneService()

    var body: some Scene {
        Window("Rclone Assistant", id: "main") {
            Group {
                if rclone.isInstalled {
                    MainView()
                } else {
                    InstallerView()
                }
            }
            .environmentObject(rclone)
        }
        .defaultSize(width: 550, height: 450)
    }
}

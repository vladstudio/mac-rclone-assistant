// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "rclone-assistant",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "rclone-assistant",
            path: "Sources"
        )
    ]
)

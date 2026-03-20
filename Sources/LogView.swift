import SwiftUI

struct LogView: View {
    @EnvironmentObject var rclone: RcloneService

    private var logText: String {
        if rclone.log.isEmpty { return "No operations yet." }
        return rclone.log.map { entry in
            let time = Self.timeFormatter.string(from: entry.date)
            let prefix = entry.isError ? "ERROR" : "OK"
            var line = "[\(time)] [\(prefix)] \(entry.command)"
            if !entry.output.isEmpty {
                line += "\n" + entry.output
            }
            return line
        }.joined(separator: "\n\n")
    }

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()

    var body: some View {
        ScrollView {
            Text(logText)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
    }
}

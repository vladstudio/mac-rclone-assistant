import Foundation

// MARK: - Provider schema (from `rclone config providers`)

struct ProviderDefinition: Decodable, Identifiable {
    let name: String
    let description: String
    let prefix: String
    let options: [OptionDefinition]
    let hide: Bool

    var id: String { name }
    var hasOAuth: Bool { options.contains { $0.name == "token" } }

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "Description"
        case prefix = "Prefix"
        case options = "Options"
        case hide = "Hide"
    }
}

struct OptionDefinition: Decodable, Identifiable {
    let name: String
    let help: String
    let defaultValue: String
    let type: String
    let required: Bool
    let advanced: Bool
    let isPassword: Bool
    let exclusive: Bool
    let sensitive: Bool
    let examples: [OptionExample]?
    let providerFilter: String?
    let hide: Int

    var id: String { name }

    var helpSummary: String {
        (help.components(separatedBy: "\n").first ?? "").trimmingCharacters(in: .whitespaces)
    }

    var isBool: Bool { type == "bool" }
    var isTristate: Bool { type == "Tristate" }
    var isInt: Bool { type == "int" }

    var hasExamples: Bool {
        examples?.isEmpty == false
    }

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case help = "Help"
        case defaultValue = "DefaultStr"
        case type = "Type"
        case required = "Required"
        case advanced = "Advanced"
        case isPassword = "IsPassword"
        case exclusive = "Exclusive"
        case sensitive = "Sensitive"
        case examples = "Examples"
        case providerFilter = "Provider"
        case hide = "Hide"
    }
}

struct OptionExample: Decodable, Identifiable {
    let value: String
    let help: String

    var id: String { value }

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case help = "Help"
    }
}

// MARK: - Remote config (from `rclone config dump`)

struct RemoteConfig: Identifiable {
    let name: String
    let type: String
    let parameters: [String: String] // does NOT contain "type" key

    var id: String { name }

    static func fromDump(_ dump: [String: [String: String]]) -> [RemoteConfig] {
        dump.map { name, params in
            var cleaned = params
            cleaned.removeValue(forKey: "type")
            return RemoteConfig(
                name: name,
                type: params["type"] ?? "unknown",
                parameters: cleaned
            )
        }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}

// MARK: - Provider setup links

struct SetupLink: Identifiable {
    let label: String
    let url: URL
    var id: URL { url }
}

private let urlPattern = try! NSRegularExpression(pattern: "https?://[^\\s\"\\\\)>]+")
private let skipHosts = ["github.com/rclone", "godoc.org", "localhost", "example.com"]

extension ProviderDefinition {
    var setupLinks: [SetupLink] {
        var result: [SetupLink] = []
        var seenLabels: Set<String> = []

        for opt in options {
            let help = opt.help
            let matches = urlPattern.matches(in: help, range: NSRange(help.startIndex..., in: help))
            for match in matches {
                guard let range = Range(match.range, in: help) else { continue }
                var urlStr = String(help[range])
                while urlStr.last == "." || urlStr.last == "," || urlStr.last == "`" {
                    urlStr.removeLast()
                }
                guard let url = URL(string: urlStr) else { continue }
                let host = url.host ?? ""
                if skipHosts.contains(where: { host.contains($0) || urlStr.contains($0) }) { continue }

                let label: String
                if opt.name.contains("api_key") || opt.name.contains("key") {
                    label = "Get API key"
                } else if opt.name.contains("token") {
                    label = "Get access token"
                } else if host.contains("console") || urlStr.contains("admin") || urlStr.contains("dashboard") {
                    label = "Provider console"
                } else {
                    label = host
                }

                if seenLabels.insert(label).inserted {
                    result.append(SetupLink(label: label, url: url))
                }
            }
        }
        return result
    }
}

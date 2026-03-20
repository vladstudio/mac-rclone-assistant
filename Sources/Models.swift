import Foundation

// MARK: - Provider schema (from `rclone config providers`)

struct ProviderDefinition: Decodable, Identifiable {
    let name: String
    let description: String
    let prefix: String
    let options: [OptionDefinition]
    let hide: Bool

    var id: String { name }

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

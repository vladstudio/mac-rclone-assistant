import SwiftUI

struct RemoteEditorView: View {
    @EnvironmentObject var rclone: RcloneService

    let mode: EditorMode
    let onSave: () -> Void
    let onCancel: () -> Void

    @State private var remoteName = ""
    @State private var selectedProvider = ""
    @State private var values: [String: String] = [:]
    @State private var showAdvanced = false
    @State private var error: String?
    @State private var saving = false
    @State private var authorizing = false
    @State private var authComplete = false

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var provider: ProviderDefinition? {
        rclone.providers.first { $0.name == selectedProvider }
    }

    private var subProviderOption: OptionDefinition? {
        provider?.options.first { $0.name == "provider" && $0.hasExamples }
    }

    private var selectedSubProvider: String {
        values["provider"] ?? ""
    }

    private var visibleOptions: [OptionDefinition] {
        guard let provider else { return [] }
        return provider.options.filter { opt in
            if opt.name == "description" { return false }
            if opt.hide != 0 { return false }
            if opt.name == "provider" && subProviderOption != nil { return false }
            if opt.advanced && !showAdvanced { return false }
            if let filter = opt.providerFilter, !filter.isEmpty, !selectedSubProvider.isEmpty {
                let allowed = filter.components(separatedBy: ",")
                if !allowed.contains(selectedSubProvider) { return false }
            }
            return true
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Form {
                nameAndTypeSection
                if provider != nil {
                    subProviderSection
                    optionsSection
                    authSection
                }
            }
            .formStyle(.grouped)

            Divider()
            bottomBar
        }
        .onAppear(perform: populateForEdit)
        .errorAlert($error)
    }

    // MARK: - Sections

    @ViewBuilder
    private var nameAndTypeSection: some View {
        Section {
            if isEditing {
                LabeledContent("Name", value: remoteName)
                LabeledContent("Type", value: selectedProvider)
            } else {
                TextField("Name", text: $remoteName)
                    .textFieldStyle(.roundedBorder)

                Picker("Storage", selection: $selectedProvider) {
                    Text("Select a provider...").tag("")
                    ForEach(rclone.providers) { p in
                        Text("\(p.name) — \(p.description)").tag(p.name)
                    }
                }
                .onChange(of: selectedProvider) {
                    values = [:]
                    authComplete = false
                }
            }
        }
    }

    @ViewBuilder
    private var subProviderSection: some View {
        if let subOpt = subProviderOption {
            Section("Provider") {
                Picker(subOpt.helpSummary.isEmpty ? "Provider" : subOpt.helpSummary,
                       selection: binding(for: "provider")) {
                    Text("Default").tag("")
                    ForEach(subOpt.examples ?? []) { ex in
                        Text("\(ex.value) — \(ex.help)").tag(ex.value)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var optionsSection: some View {
        Section {
            ForEach(visibleOptions) { opt in
                OptionFieldView(
                    option: opt,
                    value: binding(for: opt.name)
                )
            }
            Toggle("Show Advanced Options", isOn: $showAdvanced)
        }
    }

    @ViewBuilder
    private var authSection: some View {
        if let provider, provider.options.contains(where: { $0.name == "token" }) {
            Section("Authorization") {
                if authorizing {
                    HStack {
                        ProgressView().controlSize(.small)
                        Text("Waiting for browser authorization...")
                    }
                } else {
                    Button("Authorize with browser...") {
                        Task { await doAuthorize() }
                    }
                    if authComplete {
                        Text("Authorization complete")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button("Cancel") { onCancel() }
                .keyboardShortcut(.cancelAction)
            Spacer()
            Button(isEditing ? "Save" : "Create") {
                Task { await save() }
            }
            .keyboardShortcut(.defaultAction)
            .disabled(remoteName.isEmpty || selectedProvider.isEmpty || saving)
        }
        .padding()
    }

    // MARK: - Actions

    private func save() async {
        saving = true
        defer { saving = false }

        let params = values.filter { !$0.value.isEmpty }

        do {
            if isEditing {
                try await rclone.updateRemote(name: remoteName, params: params)
            } else {
                try await rclone.createRemote(name: remoteName, type: selectedProvider, params: params)
            }
            onSave()
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func doAuthorize() async {
        authorizing = true
        defer { authorizing = false }

        do {
            let output = try await rclone.authorize(backend: selectedProvider, params: values)
            if let token = extractToken(from: output) {
                values["token"] = token
                authComplete = true
            }
        } catch {
            self.error = "Authorization failed: \(error.localizedDescription)"
        }
    }

    /// Extract the OAuth token JSON from rclone authorize output.
    /// Uses brace-counting to find the JSON boundary, then validates with JSONSerialization.
    /// Note: if rclone's output format changes, this may need updating.
    private func extractToken(from output: String) -> String? {
        guard let start = output.range(of: "{\"access_token\"")?.lowerBound else { return nil }
        var braceCount = 0
        var end = start
        for i in output[start...].indices {
            if output[i] == "{" { braceCount += 1 }
            if output[i] == "}" { braceCount -= 1 }
            if braceCount == 0 { end = i; break }
        }
        let candidate = String(output[start...end])
        guard let data = candidate.data(using: .utf8),
              (try? JSONSerialization.jsonObject(with: data)) != nil
        else { return nil }
        return candidate
    }

    private func populateForEdit() {
        if case .edit(let remote) = mode {
            remoteName = remote.name
            selectedProvider = remote.type
            values = remote.parameters
        }
    }

    private func binding(for key: String) -> Binding<String> {
        Binding(
            get: { values[key] ?? "" },
            set: { values[key] = $0 }
        )
    }
}

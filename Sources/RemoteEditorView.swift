import SwiftUI

enum EditorMode {
    case add
    case edit(RemoteConfig)
}

struct RemoteEditorView: View {
    @EnvironmentObject var rclone: RcloneService
    @Environment(\.dismiss) var dismiss

    let mode: EditorMode
    let onSave: () -> Void

    @State private var remoteName = ""
    @State private var selectedProvider = ""
    @State private var selectedSubProvider = ""
    @State private var values: [String: String] = [:]
    @State private var showAdvanced = false
    @State private var error: String?
    @State private var saving = false
    @State private var authorizing = false
    @State private var authOutput = ""

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var provider: ProviderDefinition? {
        rclone.providers.first { $0.name == selectedProvider }
    }

    // The "provider" option (e.g. S3 sub-provider like AWS, Cloudflare)
    private var subProviderOption: OptionDefinition? {
        provider?.options.first { $0.name == "provider" && $0.examples != nil && !$0.examples!.isEmpty }
    }

    private var visibleOptions: [OptionDefinition] {
        guard let provider else { return [] }
        return provider.options.filter { opt in
            // Skip the "type" pseudo-option and description (handled separately)
            if opt.name == "description" { return false }
            // Skip hidden
            if opt.hide != 0 { return false }
            // Skip the sub-provider selector itself (shown separately)
            if opt.name == "provider" && subProviderOption != nil { return false }
            // Advanced filter
            if opt.advanced && !showAdvanced { return false }
            // Sub-provider filter (e.g., S3 options filtered by AWS/Cloudflare/etc)
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
        .frame(minWidth: 550, minHeight: 400)
        .onAppear(perform: populateForEdit)
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            Text(error ?? "")
        }
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
                    selectedSubProvider = ""
                }
            }
        }
    }

    @ViewBuilder
    private var subProviderSection: some View {
        if let subOpt = subProviderOption {
            Section("Provider") {
                Picker(subOpt.help.components(separatedBy: "\n").first ?? "Provider", selection: $selectedSubProvider) {
                    Text("Default").tag("")
                    ForEach(subOpt.examples ?? []) { ex in
                        Text("\(ex.value) — \(ex.help)").tag(ex.value)
                    }
                }
                .onChange(of: selectedSubProvider) {
                    values["provider"] = selectedSubProvider
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
                    value: binding(for: opt.name, default: opt.defaultValue)
                )
            }

            Toggle("Show Advanced Options", isOn: $showAdvanced)
        }
    }

    @ViewBuilder
    private var authSection: some View {
        // Show authorize button if this provider likely needs OAuth
        // (has a "token" option or "client_id" option)
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
                    if !authOutput.isEmpty {
                        Text("Authorization complete")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
    }

    private var bottomBar: some View {
        HStack {
            Button("Cancel") { dismiss() }
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

        // Filter out empty values and defaults
        let params = values.filter { !$0.value.isEmpty }

        do {
            if isEditing {
                try await rclone.updateRemote(name: remoteName, params: params)
            } else {
                try await rclone.createRemote(name: remoteName, type: selectedProvider, params: params)
            }
            onSave()
            dismiss()
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func doAuthorize() async {
        authorizing = true
        defer { authorizing = false }

        do {
            let output = try await rclone.authorize(backend: selectedProvider, params: values)
            authOutput = output
            // Try to extract token from output
            if let range = output.range(of: "{\"access_token\"") {
                // Find the full JSON token - could span multiple braces
                let tokenStart = range.lowerBound
                var braceCount = 0
                var tokenEnd = tokenStart
                for i in output[tokenStart...].indices {
                    if output[i] == "{" { braceCount += 1 }
                    if output[i] == "}" { braceCount -= 1 }
                    if braceCount == 0 { tokenEnd = i; break }
                }
                let token = String(output[tokenStart...tokenEnd])
                values["token"] = token
            }
        } catch {
            self.error = "Authorization failed: \(error.localizedDescription)"
        }
    }

    private func populateForEdit() {
        if case .edit(let remote) = mode {
            remoteName = remote.name
            selectedProvider = remote.type
            values = remote.parameters
            values.removeValue(forKey: "type")
            if let sub = values["provider"] {
                selectedSubProvider = sub
            }
        }
    }

    private func binding(for key: String, default defaultValue: String) -> Binding<String> {
        Binding(
            get: { values[key] ?? "" },
            set: { values[key] = $0 }
        )
    }
}

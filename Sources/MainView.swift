import SwiftUI

enum Screen {
    case list
    case editor(EditorMode)
}

enum EditorMode {
    case add
    case edit(RemoteConfig)
}

struct MainView: View {
    @EnvironmentObject var rclone: RcloneService
    @State private var screen: Screen = .list
    @State private var error: String?
    @State private var loading = true
    @State private var remoteToDelete: RemoteConfig?
    @State private var renameTarget: RemoteConfig?
    @State private var newName = ""
    @Environment(\.openWindow) private var openWindow

    private var isListScreen: Bool {
        if case .list = screen { return true }
        return false
    }

    var body: some View {
        VStack(spacing: 0) {
            switch screen {
            case .list:
                listContent
            case .editor(let mode):
                RemoteEditorView(mode: mode) {
                    screen = .list
                    Task { await reload() }
                } onCancel: {
                    screen = .list
                }
                .environmentObject(rclone)
            }
        }
        .frame(width: 500)
        .frame(minHeight: isListScreen ? nil : 450,
               maxHeight: isListScreen ? nil : .infinity)
        .navigationTitle(windowTitle)
        .toolbar { toolbarContent }
        .errorAlert($error)
        .alert("Delete Remote",
               isPresented: .isNotNil($remoteToDelete)) {
            Button("Cancel", role: .cancel) { remoteToDelete = nil }
            Button("Delete", role: .destructive) {
                if let r = remoteToDelete {
                    Task { await deleteRemote(r) }
                }
            }
        } message: {
            Text("Delete \"\(remoteToDelete?.name ?? "")\"? This cannot be undone.")
        }
        .sheet(isPresented: .isNotNil($renameTarget), onDismiss: { renameTarget = nil; newName = "" }) {
            RenameSheet(name: $newName) {
                if let r = renameTarget {
                    let captured = newName
                    renameTarget = nil
                    newName = ""
                    Task { await doRename(r, to: captured) }
                }
            }
        }
        .task { await reload(showSpinner: true) }
    }

    private var windowTitle: String {
        switch screen {
        case .list: "Rclone Assistant"
        case .editor(.add): "Add Remote"
        case .editor(.edit(let r)): r.name
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        switch screen {
        case .list:
            ToolbarItem(placement: .automatic) {
                Button("Log", systemImage: "doc.text") {
                    openWindow(id: "log")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Add", systemImage: "plus") {
                    screen = .editor(.add)
                }
            }
        case .editor:
            // Editor manages its own toolbar via Cancel/Save in RemoteEditorView
            ToolbarItem(placement: .automatic) {
                EmptyView()
            }
        }
    }

    // MARK: - List content

    @ViewBuilder
    private var listContent: some View {
        if loading {
            ProgressView("Loading remotes...")
                .frame(height: 200)
        } else if rclone.remotes.isEmpty {
            emptyState
        } else {
            remoteList
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "externaldrive")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("No remotes configured")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("Add a remote to get started with rclone.")
                .font(.callout)
                .foregroundStyle(.tertiary)
            Button("Add Remote") {
                screen = .editor(.add)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
        .frame(height: 300)
    }

    private var remoteList: some View {
        VStack(spacing: 0) {
            ForEach(rclone.remotes) { remote in
                remoteRow(remote)
                if remote.id != rclone.remotes.last?.id {
                    Divider()
                }
            }
        }
        .padding()
    }

    private func remoteRow(_ remote: RemoteConfig) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(remote.name)
                    .font(.headline)
                Text(rclone.providerDescriptions[remote.type] ?? remote.type)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 12) {
                Button { newName = remote.name; renameTarget = remote } label: {
                    Image(systemName: "pencil")
                }
                .help("Rename")
                Button { screen = .editor(.edit(remote)) } label: {
                    Image(systemName: "gearshape")
                }
                .help("Edit")
                Button { remoteToDelete = remote } label: {
                    Image(systemName: "trash")
                }
                .help("Delete")
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }

    // MARK: - Actions

    private func reload(showSpinner: Bool = false) async {
        if showSpinner { loading = true }
        defer { if showSpinner { loading = false } }
        do {
            async let p: () = rclone.loadProvidersIfNeeded()
            async let r: () = rclone.loadRemotes()
            try await p
            try await r
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func deleteRemote(_ remote: RemoteConfig) async {
        remoteToDelete = nil
        do {
            try await rclone.deleteRemote(name: remote.name)
            await reload()
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func doRename(_ remote: RemoteConfig, to name: String) async {
        guard !name.isEmpty, name != remote.name else { return }
        do {
            try await rclone.renameRemote(oldName: remote.name, newName: name, params: remote.parameters, type: remote.type)
            await reload()
        } catch {
            self.error = error.localizedDescription
        }
    }
}

// MARK: - Rename Sheet

private struct RenameSheet: View {
    @Binding var name: String
    let onRename: () -> Void
    @Environment(\.dismiss) var dismiss
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("Rename Remote")
                .font(.headline)
            TextField("New name", text: $name)
                .textFieldStyle(.roundedBorder)
                .focused($focused)
                .onSubmit { onRename() }
            HStack {
                Button("Cancel") { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Spacer()
                Button("Rename") { onRename() }
                    .keyboardShortcut(.defaultAction)
                    .disabled(name.isEmpty)
            }
        }
        .padding()
        .frame(width: 300)
        .onAppear { focused = true }
    }
}

// MARK: - Binding helpers

extension Binding where Value == Bool {
    @MainActor
    static func isNotNil<T>(_ source: Binding<T?>) -> Binding<Bool> {
        Binding(
            get: { source.wrappedValue != nil },
            set: { if !$0 { source.wrappedValue = nil } }
        )
    }
}

extension View {
    func errorAlert(_ error: Binding<String?>) -> some View {
        alert("Error", isPresented: .isNotNil(error)) {
            Button("OK") { error.wrappedValue = nil }
        } message: {
            Text(error.wrappedValue ?? "")
        }
    }
}

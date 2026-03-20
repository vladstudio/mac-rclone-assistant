import SwiftUI

struct MainView: View {
    @EnvironmentObject var rclone: RcloneService
    @State private var error: String?
    @State private var loading = true
    @State private var showEditor = false
    @State private var editorMode: EditorMode = .add
    @State private var remoteToDelete: RemoteConfig?
    @State private var renameTarget: RemoteConfig?
    @State private var newName = ""

    var body: some View {
        Group {
            if loading {
                ProgressView("Loading remotes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if rclone.remotes.isEmpty {
                emptyState
            } else {
                remoteList
            }
        }
        .frame(minWidth: 450, minHeight: 300)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    editorMode = .add
                    showEditor = true
                } label: {
                    Label("Add Remote", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            RemoteEditorView(mode: editorMode, onSave: { Task { await reload() } })
                .environmentObject(rclone)
        }
        .alert("Error", isPresented: .constant(error != nil)) {
            Button("OK") { error = nil }
        } message: {
            Text(error ?? "")
        }
        .alert("Delete Remote", isPresented: .constant(remoteToDelete != nil)) {
            Button("Cancel", role: .cancel) { remoteToDelete = nil }
            Button("Delete", role: .destructive) {
                if let r = remoteToDelete {
                    Task { await deleteRemote(r) }
                }
            }
        } message: {
            Text("Delete \"\(remoteToDelete?.name ?? "")\"? This cannot be undone.")
        }
        .alert("Rename Remote", isPresented: .constant(renameTarget != nil)) {
            TextField("New name", text: $newName)
            Button("Cancel", role: .cancel) { renameTarget = nil; newName = "" }
            Button("Rename") {
                if let r = renameTarget {
                    Task { await doRename(r) }
                }
            }
        } message: {
            Text("Enter new name for \"\(renameTarget?.name ?? "")\":")
        }
        .task { await reload() }
    }

    // MARK: - Subviews

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "externaldrive")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No remotes configured")
                .font(.title3)
                .foregroundStyle(.secondary)
            Button("Add Remote") {
                editorMode = .add
                showEditor = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var remoteList: some View {
        List {
            ForEach(rclone.remotes) { remote in
                remoteRow(remote)
            }
        }
    }

    private func remoteRow(_ remote: RemoteConfig) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(remote.name)
                    .font(.headline)
                Text(providerDescription(for: remote.type))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(remote.type)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(.quaternary)
                .clipShape(Capsule())

            Menu {
                Button("Edit") {
                    editorMode = .edit(remote)
                    showEditor = true
                }
                Button("Rename") {
                    newName = remote.name
                    renameTarget = remote
                }
                Divider()
                Button("Delete", role: .destructive) {
                    remoteToDelete = remote
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .menuStyle(.borderlessButton)
            .frame(width: 30)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Actions

    private func reload() async {
        loading = true
        defer { loading = false }
        do {
            try await rclone.loadProviders()
            try await rclone.loadRemotes()
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

    private func doRename(_ remote: RemoteConfig) async {
        let name = newName
        renameTarget = nil
        newName = ""
        guard !name.isEmpty, name != remote.name else { return }
        do {
            try await rclone.renameRemote(oldName: remote.name, newName: name)
            await reload()
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func providerDescription(for type: String) -> String {
        rclone.providers.first { $0.name == type }?.description ?? type
    }
}

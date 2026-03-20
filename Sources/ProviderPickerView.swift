import SwiftUI

struct ProviderPickerView: View {
    let providers: [ProviderDefinition]
    @Binding var selection: String
    @State private var search = ""
    @FocusState private var focused: Bool

    private var sorted: [ProviderDefinition] {
        providers.sorted { $0.description.localizedCaseInsensitiveCompare($1.description) == .orderedAscending }
    }

    private var filtered: [ProviderDefinition] {
        if search.isEmpty { return sorted }
        let q = search.lowercased()
        return sorted.filter {
            $0.description.lowercased().contains(q) || $0.name.lowercased().contains(q)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search providers...", text: $search)
                    .textFieldStyle(.plain)
                    .focused($focused)
                if !search.isEmpty {
                    Button {
                        search = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.borderless)
                }
            }
            .padding(8)

            Divider()

            List(filtered) { p in
                VStack(alignment: .leading, spacing: 2) {
                    Text(p.description)
                    Text(p.name)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture { selection = p.name }
                .listRowBackground(selection == p.name ? Color.accentColor.opacity(0.15) : Color.clear)
            }
            .listStyle(.plain)
        }
        .onAppear { focused = true }
    }
}

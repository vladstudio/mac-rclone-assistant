import SwiftUI

struct OptionFieldView: View {
    let option: OptionDefinition
    @Binding var value: String
    @State private var showPassword = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            fieldControl
            if !helpText.isEmpty {
                Text(helpText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
    }

    @ViewBuilder
    private var fieldControl: some View {
        if let examples = option.examples, !examples.isEmpty {
            pickerField(examples: examples)
        } else if option.type == "bool" {
            toggleField
        } else if option.type == "Tristate" {
            tristateField
        } else if option.isPassword {
            passwordField
        } else if option.type == "int" {
            numericField
        } else {
            textField
        }
    }

    private func pickerField(examples: [OptionExample]) -> some View {
        Picker(label, selection: $value) {
            if !option.required {
                Text("Default").tag("")
            }
            ForEach(examples) { ex in
                Text(ex.value + (ex.help.isEmpty ? "" : " — \(ex.help)"))
                    .tag(ex.value)
                    .help(ex.help)
            }
        }
    }

    private var toggleField: some View {
        Picker(label, selection: $value) {
            Text("Default").tag("")
            Text("true").tag("true")
            Text("false").tag("false")
        }
    }

    private var tristateField: some View {
        Picker(label, selection: $value) {
            Text("Default (unset)").tag("")
            Text("true").tag("true")
            Text("false").tag("false")
        }
    }

    private var passwordField: some View {
        HStack {
            if showPassword {
                TextField(label, text: $value)
                    .textFieldStyle(.roundedBorder)
            } else {
                SecureField(label, text: $value)
                    .textFieldStyle(.roundedBorder)
            }
            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
            }
            .buttonStyle(.borderless)
        }
    }

    private var numericField: some View {
        TextField(label, text: $value)
            .textFieldStyle(.roundedBorder)
    }

    private var textField: some View {
        TextField(label, text: $value)
            .textFieldStyle(.roundedBorder)
    }

    private var label: String {
        option.required ? "\(option.name) *" : option.name
    }

    private var helpText: String {
        // First line of help, cleaned up
        let first = option.help.components(separatedBy: "\n").first ?? ""
        return first.trimmingCharacters(in: .whitespaces)
    }
}

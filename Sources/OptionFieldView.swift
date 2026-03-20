import SwiftUI

struct OptionFieldView: View {
    let option: OptionDefinition
    @Binding var value: String
    @State private var showPassword = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            fieldControl
            if !option.helpSummary.isEmpty {
                Text(option.helpSummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
    }

    @ViewBuilder
    private var fieldControl: some View {
        if option.hasExamples {
            pickerField(examples: option.examples!)
        } else if option.isBool || option.isTristate {
            boolField(unsetLabel: option.isTristate ? "Default (unset)" : "Default")
        } else if option.isPassword {
            passwordField
        } else if option.isInt {
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

    private func boolField(unsetLabel: String) -> some View {
        Picker(label, selection: $value) {
            Text(unsetLabel).tag("")
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
            .onChange(of: value) {
                let filtered = String(value.enumerated().filter { i, c in
                    c.isNumber || (c == "-" && i == 0)
                }.map(\.element))
                if filtered != value { value = filtered }
            }
    }

    private var textField: some View {
        TextField(label, text: $value)
            .textFieldStyle(.roundedBorder)
    }

    private var label: String {
        option.required ? "\(option.name) *" : option.name
    }
}

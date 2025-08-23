import SwiftUI

struct ManualEntryView: View {
    @Binding var value: Int
    let title: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Log your time")) {
                    TextField("Minutes", value: $value, format: .number)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

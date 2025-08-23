import SwiftUI

struct EditSubtaskView: View {
    @Binding var subtask: Task
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sub-task Details")) {
                    TextField("Sub-task Title", text: $subtask.title)

                    Toggle("Add Due Date", isOn: Binding(
                        get: { subtask.dueDate != nil },
                        set: { hasDueDate in
                            if hasDueDate {
                                subtask.dueDate = Date()
                            } else {
                                subtask.dueDate = nil
                            }
                        }
                    ))

                    if let dueDate = subtask.dueDate {
                        DatePicker("Due Date", selection: Binding(
                            get: { dueDate },
                            set: { subtask.dueDate = $0 }
                        ), displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Edit Sub-task")
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

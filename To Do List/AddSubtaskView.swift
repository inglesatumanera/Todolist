import SwiftUI

struct AddSubtaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var subtasks: [Task]?

    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    
    // A local copy of the subtasks array to make changes to
    @State private var localSubtasks: [Task] = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Sub-Task")) {
                    TextField("Sub-Task Title", text: $title)
                }

                Section(header: Text("Due Date")) {
                    Toggle("Add Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate)
                    }
                }
            }
            .navigationTitle("Add Sub-Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSubtask()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
        .onAppear {
            // When the view appears, create a local copy of the subtasks
            localSubtasks = subtasks ?? []
        }
        .onDisappear {
            // When the view disappears, save the local copy back to the binding
            subtasks = localSubtasks
        }
    }

    private func saveSubtask() {
        let newSubtask = Task(
            title: title,
            type: .simple,
            status: .todo,
            category: .personal,
            dueDate: hasDueDate ? dueDate : nil,
            subtasks: nil
        )
        
        // Append the new subtask to the local array
        localSubtasks.append(newSubtask)
    }
}

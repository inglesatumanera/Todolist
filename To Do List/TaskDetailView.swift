import SwiftUI

struct TaskDetailView: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Task Title", text: $task.title)

                if let dueDate = task.dueDate {
                    DatePicker("Due Date", selection: Binding(
                        get: { dueDate },
                        set: { task.dueDate = $0 }
                    ), displayedComponents: .date)
                } else {
                    // Provide a way to set a due date if it's nil
                    Button("Add Due Date") {
                        task.dueDate = Date()
                    }
                }
            }

            Section(header: Text("Notes")) {
                TextEditor(text: Binding(
                    get: { task.details ?? "" },
                    set: { task.details = $0 }
                ))
                .frame(height: 200)
            }
        }
        .navigationTitle("Edit Task")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    NotificationManager.shared.scheduleTaskReminder(task: task)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

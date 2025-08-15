import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [Task]
    let selectedCategory: TaskCategory

    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var taskType: TaskType = .simple

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $title)
                    
                    Picker("Type", selection: $taskType) {
                        Text("Simple Task").tag(TaskType.simple)
                        Text("Project").tag(TaskType.project)
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Due Date")) {
                    Toggle("Add Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Due Date", selection: $dueDate)
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTask()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveTask() {
        let newTask = Task(
            title: title,
            type: taskType,
            status: .todo,
            category: selectedCategory,
            dueDate: hasDueDate ? dueDate : nil,
            subtasks: nil // Projects will be handled later
        )
        tasks.append(newTask)
    }
}

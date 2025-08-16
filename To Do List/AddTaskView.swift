import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData
    let selectedSubCategoryID: UUID

    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var taskType: TaskType = .simple
    @State private var subCategoryID: UUID

    init(tasks: Binding<[Task]>, categoryData: Binding<CategoryManager.CategoryData>, selectedSubCategoryID: UUID) {
        self._tasks = tasks
        self._categoryData = categoryData
        self.selectedSubCategoryID = selectedSubCategoryID
        self._subCategoryID = State(initialValue: selectedSubCategoryID)
    }

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

                    Picker("Category", selection: $subCategoryID) {
                        ForEach(categoryData.categories) { category in
                            Section(header: Text(category.name)) {
                                ForEach(categoryData.subCategories.filter { $0.parentCategoryID == category.id }) { subCategory in
                                    Text(subCategory.name).tag(subCategory.id)
                                }
                            }
                        }
                    }
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
            subCategoryID: subCategoryID,
            dueDate: hasDueDate ? dueDate : nil,
            subtasks: taskType == .project ? [] : nil
        )
        tasks.append(newTask)
    }
}

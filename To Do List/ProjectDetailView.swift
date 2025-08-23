import SwiftUI

struct ProjectDetailView: View {
    @Binding var project: Task
    @State private var showingAddSubtask = false
    @State private var selectedSubtask: Task?

    // Custom binding to handle the optional subtasks array
    private var subtasksBinding: Binding<[Task]> {
        Binding(
            get: { self.project.subtasks ?? [] },
            set: { self.project.subtasks = $0 }
        )
    }

    var body: some View {
        List {
            Section {
                NavigationLink(destination: TaskDetailView(task: $project)) {
                    Text("Edit Project Details")
                }
            }

            Section(header: Text("Sub-Tasks")) {
                if project.subtasks?.isEmpty ?? true {
                    Text("No sub-tasks yet. Tap the '+' to add one.")
                        .foregroundColor(.secondary)
                }
                
                ForEach(subtasksBinding) { $subtask in
                    Button(action: {
                        selectedSubtask = subtask
                    }) {
                        Text(subtask.title)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .navigationTitle(project.title)
        .toolbar {
            Button(action: {
                showingAddSubtask = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddSubtask) {
            AddSubtaskView(subtasks: $project.subtasks)
        }
        .sheet(item: $selectedSubtask) { subtask in
            // Find the binding to the selected subtask
            if let index = project.subtasks?.firstIndex(where: { $0.id == subtask.id }) {
                EditSubtaskView(subtask: $project.subtasks![index])
            }
        }
    }
}

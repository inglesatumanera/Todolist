import SwiftUI

struct ProjectDetailView: View {
    @Binding var project: Task
    @State private var showingAddSubtask = false

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
                
                ForEach(project.subtasks ?? [], id: \.id) { subtask in
                    Text(subtask.title)
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
    }
}

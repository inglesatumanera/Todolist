import SwiftUI

struct ContentView: View {
    @Binding var tasks: [Task]
    let selectedCategory: TaskCategory

    @State private var showingAddTask = false

    var body: some View {
        TabView {
            TaskColumn(title: "To-Do", tasks: $tasks, status: .todo, selectedCategory: selectedCategory)
            TaskColumn(title: "In Progress", tasks: $tasks, status: .inProgress, selectedCategory: selectedCategory)
            TaskColumn(title: "Completed", tasks: $tasks, status: .completed, selectedCategory: selectedCategory)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .navigationTitle(selectedCategory.rawValue)
        .toolbar {
            Button(action: {
                showingAddTask = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(tasks: $tasks, selectedCategory: selectedCategory)
        }
    }
}

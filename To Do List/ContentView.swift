import SwiftUI

struct ContentView: View {
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData // New: Add this binding
    let selectedSubCategory: SubCategory

    @State private var showingAddTask = false

    var body: some View {
        TabView {
            TaskColumn(title: "To-Do", tasks: $tasks, status: .todo, subCategoryID: selectedSubCategory.id)
            TaskColumn(title: "In Progress", tasks: $tasks, status: .inProgress, subCategoryID: selectedSubCategory.id)
            TaskColumn(title: "Completed", tasks: $tasks, status: .completed, subCategoryID: selectedSubCategory.id)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .navigationTitle(selectedSubCategory.name)
        .toolbar {
            Button(action: {
                showingAddTask = true
            }) {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(
                tasks: $tasks,
                categoryData: $categoryData, // New: Pass the categoryData binding
                selectedSubCategoryID: selectedSubCategory.id
            )
        }
    }
}

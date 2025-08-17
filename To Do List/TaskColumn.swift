import SwiftUI

struct TaskColumn: View {
    let title: String
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData
    let status: TaskStatus
    let subCategoryID: UUID

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 8)

            ScrollView {
                ForEach($tasks.filter { $0.status.wrappedValue == status && $0.subCategoryID.wrappedValue == subCategoryID }) { $task in
                    TaskCard(task: $task, allTasks: $tasks, categoryData: $categoryData)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

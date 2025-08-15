import SwiftUI

struct TaskColumn: View {
    let title: String
    @Binding var tasks: [Task]
    let status: TaskStatus
    let selectedCategory: TaskCategory

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 8)

            ScrollView {
                ForEach($tasks.filter { $0.status.wrappedValue == status && $0.category.wrappedValue == selectedCategory }) { $task in
                    TaskCard(task: $task, allTasks: $tasks)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

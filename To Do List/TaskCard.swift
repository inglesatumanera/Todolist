import SwiftUI

struct TaskCard: View {
    @Binding var task: Task
    @Binding var allTasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData

    var body: some View {
        Group {
            // Use a NavigationLink to handle tapping on a project card
            if task.type == .project {
                NavigationLink(destination: ProjectDetailView(project: $task)) {
                    cardContent
                }
            } else {
                NavigationLink(destination: TaskDetailView(task: $task)) {
                    cardContent
                }
            }
        }
        .contextMenu {
            if task.status == .todo {
                Button {
                    moveTask(to: .inProgress)
                } label: {
                    Label("Start Task", systemImage: "play.circle")
                }
            }

            if task.status != .completed {
                Button {
                    moveTask(to: .completed)
                } label: {
                    Label("Complete Task", systemImage: "checkmark.circle")
                }
            }
        }
    }

    private var cardContent: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(categoryColor)
                .frame(width: 5)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                    .lineLimit(2)
                Spacer()
                if task.type == .project {
                    Image(systemName: "folder")
                        .foregroundColor(.blue)
                }
            }

            HStack {
                if let dueDate = task.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .foregroundColor(dueDateColor(for: dueDate))
                        Text(formattedDate(for: dueDate))
                            .font(.caption)
                            .foregroundColor(dueDateColor(for: dueDate))
                    }
                }
                Spacer()
                
                Menu {
                    Button("To-Do") { moveTask(to: .todo) }
                    Button("In Progress") { moveTask(to: .inProgress) }
                    Button("Completed") { moveTask(to: .completed) }
                } label: {
                    Text(statusLabel)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(statusColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    private var categoryColor: Color {
        guard let subCategoryID = task.subCategoryID,
              let subCategory = categoryData.subCategories.first(where: { $0.id == subCategoryID }),
              let category = categoryData.categories.first(where: { $0.id == subCategory.parentCategoryID }) else {
            return .gray // Default color
        }
        return category.color
    }

    func moveTask(to newStatus: TaskStatus) {
        if let index = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks[index].status = newStatus
            if newStatus == .completed {
                allTasks[index].completionDate = Date()
            } else {
                // Optional: Clear the completion date if moved out of completed
                allTasks[index].completionDate = nil
            }
        }
    }

    private func formattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    private var statusColor: Color {
        switch task.status {
        case .todo: return .gray
        case .inProgress: return .blue
        case .completed: return .green
        }
    }

    private var statusLabel: String {
        switch task.status {
        case .todo: return "To-Do"
        case .inProgress: return "In Progress"
        case .completed: return "Done"
        }
    }

    private func dueDateColor(for date: Date) -> Color {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return .blue
        } else if date < Date() {
            return .red
        } else {
            return .secondary
        }
    }
}

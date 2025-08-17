import SwiftUI

struct TaskCard: View {
    @Binding var task: Task
    @Binding var allTasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData

    var body: some View {
        Group {
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
                    self.moveTask(to: .inProgress)
                } label: {
                    Label("Start Task", systemImage: "play.circle")
                }
            }

            if task.status != .completed {
                Button {
                    self.moveTask(to: .completed)
                } label: {
                    Label("Complete Task", systemImage: "checkmark.circle")
                }
            }
        }
    }

    private var cardContent: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(self.categoryColor)
                .frame(width: 5)
                .cornerRadius(2.5) // Optional: to make the bar's ends rounded
                .padding(.leading, -5) // Adjust padding to keep alignment clean

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
                                .foregroundColor(self.dueDateColor(for: dueDate))
                            Text(self.formattedDate(for: dueDate))
                                .font(.caption)
                                .foregroundColor(self.dueDateColor(for: dueDate))
                        }
                    }
                    Spacer()

                    Menu {
                        Button("To-Do") { self.moveTask(to: .todo) }
                        Button("In Progress") { self.moveTask(to: .inProgress) }
                        Button("Completed") { self.moveTask(to: .completed) }
                    } label: {
                        Text(self.statusLabel)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(self.statusColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground)) // Use system background for light/dark mode adaptability
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
        // Find the index of the root task
        if let rootIndex = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks[rootIndex].status = newStatus
            if newStatus == .completed {
                allTasks[rootIndex].completionDate = Date()
            } else {
                allTasks[rootIndex].completionDate = nil
            }
            return
        }

        // Find the index of the subtask if the root task isn't found
        for i in allTasks.indices {
            if let subtaskIndex = allTasks[i].subtasks?.firstIndex(where: { $0.id == task.id }) {
                allTasks[i].subtasks?[subtaskIndex].status = newStatus
                if newStatus == .completed {
                    allTasks[i].subtasks?[subtaskIndex].completionDate = Date()
                } else {
                    allTasks[i].subtasks?[subtaskIndex].completionDate = nil
                }
                return
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

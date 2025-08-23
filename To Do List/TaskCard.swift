import SwiftUI
import UserNotifications

struct TaskCard: View {
    @Binding var task: Task
    @Binding var allTasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData
    @State private var showingTimerOptions = false
    @State private var showingCustomTimerSheet = false

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
        .confirmationDialog("Select Timer Duration", isPresented: $showingTimerOptions, titleVisibility: .visible) {
            Button("10 Minutes") { startTimer(minutes: 10) }
            Button("25 Minutes (Pomodoro)") { startTimer(minutes: 25) }
            Button("Custom...") { showingCustomTimerSheet = true }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingCustomTimerSheet) {
            TimerSetupView(task: task)
        }
    }

    private var cardContent: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(self.categoryColor)
                .frame(width: 5)
                .cornerRadius(2.5)
                .padding(.leading, -5)

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

                    if task.status == .inProgress {
                        Button(action: { showingTimerOptions = true }) {
                            Image(systemName: "timer")
                                .font(.caption)
                                .padding(4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }

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
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private func startTimer(minutes: Int) {
        NotificationManager.shared.scheduleTimerNotification(
            task: task,
            duration: TimeInterval(minutes * 60),
            sound: UNNotificationSoundName(rawValue: "alarm_tone_1.caf")
        )
    }

    private var categoryColor: Color {
        guard let subCategoryID = task.subCategoryID,
              let subCategory = categoryData.subCategories.first(where: { $0.id == subCategoryID }),
              let category = categoryData.categories.first(where: { $0.id == subCategory.parentCategoryID }) else {
            return .gray
        }
        return category.color
    }

    func moveTask(to newStatus: TaskStatus) {
        if let rootIndex = allTasks.firstIndex(where: { $0.id == task.id }) {
            allTasks[rootIndex].status = newStatus
            if newStatus == .completed {
                allTasks[rootIndex].completionDate = Date()
            } else {
                allTasks[rootIndex].completionDate = nil
            }
            return
        }

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

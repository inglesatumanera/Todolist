import SwiftUI

struct CompletedTasksView: View {
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData

    private var completedTasksByDay: [Date: [Task]] {
        let completed = tasks.filter { $0.status == .completed && $0.completionDate != nil }

        return Dictionary(grouping: completed) { task in
            // Normalize the date to the start of the day
            return Calendar.current.startOfDay(for: task.completionDate!)
        }
    }

    private var sortedDays: [Date] {
        return completedTasksByDay.keys.sorted(by: >) // Sort days in descending order
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(sortedDays, id: \.self) { day in
                    Section(header: Text(formattedHeader(for: day))) {
                        ForEach(completedTasksByDay[day]!) { task in
                            if let binding = binding(for: task) {
                                TaskCard(task: binding, allTasks: $tasks, categoryData: $categoryData)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Completed Tasks")
        }
    }

    private func binding(for task: Task) -> Binding<Task>? {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            return $tasks[index]
        }

        for parentIndex in tasks.indices {
            if let subtaskIndex = tasks[parentIndex].subtasks?.firstIndex(where: { $0.id == task.id }) {
                return Binding(
                    get: {
                        return tasks[parentIndex].subtasks![subtaskIndex]
                    },
                    set: {
                        tasks[parentIndex].subtasks![subtaskIndex] = $0
                    }
                )
            }
        }

        return nil
    }

    private func formattedHeader(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }
}

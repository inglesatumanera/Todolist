import SwiftUI

struct MonthlyReviewSummaryView: View {
    let tasks: [Task]
    let date: Date

    private var lastMonthInterval: DateInterval? {
        guard let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: date) else {
            return nil
        }
        return Calendar.current.dateInterval(of: .month, for: lastMonth)
    }

    private var tasksDueLastMonth: [Task] {
        guard let interval = lastMonthInterval else { return [] }
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return interval.contains(dueDate)
        }
    }

    private var tasksCompletedLastMonth: [Task] {
        guard let interval = lastMonthInterval else { return [] }
        return tasks.filter { task in
            guard let completionDate = task.completionDate else { return false }
            return interval.contains(completionDate)
        }
    }

    private var completionPercentage: Int {
        let dueTasks = tasksDueLastMonth
        guard !dueTasks.isEmpty else { return 100 }

        let completedFromDue = dueTasks.filter { $0.status == .completed }
        return Int((Double(completedFromDue.count) / Double(dueTasks.count)) * 100)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Last Month's Summary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                Text("\(completionPercentage)%")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.green)

                Text("Task Completion Rate")
                    .font(.title3)
                    .foregroundColor(.secondary)

                Divider().padding()

                HStack(spacing: 20) {
                    VStack {
                        Text("\(tasksDueLastMonth.count)")
                            .font(.largeTitle.bold())
                        Text("Tasks Planned")
                            .font(.caption)
                    }
                    VStack {
                        Text("\(tasksCompletedLastMonth.count)")
                            .font(.largeTitle.bold())
                        Text("Total Completed")
                            .font(.caption)
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

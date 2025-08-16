import SwiftUI

struct WeeklyReviewAccomplishmentView: View {
    let tasks: [Task]
    let date: Date

    private var lastWeekInterval: DateInterval? {
        guard let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: date) else {
            return nil
        }
        return Calendar.current.dateInterval(of: .weekOfYear, for: lastWeek)
    }

    private var plannedLastWeek: [Task] {
        guard let interval = lastWeekInterval else { return [] }
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return interval.contains(dueDate)
        }
    }

    private var completedLastWeek: [Task] {
        guard let interval = lastWeekInterval else { return [] }
        return tasks.filter { task in
            guard let completionDate = task.completionDate else { return false }
            return interval.contains(completionDate)
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Last Week's Review")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("You Planned to Do (\(plannedLastWeek.count))")
                            .font(.title2).fontWeight(.semibold)
                        ForEach(plannedLastWeek) { task in
                            Text(task.title)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("You Actually Completed (\(completedLastWeek.count))")
                            .font(.title2).fontWeight(.semibold)
                            .padding(.top)
                        ForEach(completedLastWeek) { task in
                            Text(task.title)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

import SwiftUI

struct WeekView: View {
    @Binding var tasks: [Task]
    @State private var currentWeek: [Date] = []

    var body: some View {
        VStack(spacing: 20) {
            WeeklyFocusView(date: Date())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(currentWeek, id: \.self) { day in
                        dayView(for: day)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 100)

            // Placeholder for tasks of the selected day
            Spacer()
            Text("Tasks for the selected day will appear here.")
            Spacer()
        }
        .onAppear {
            fetchCurrentWeek()
        }
    }

    // A view for a single day in the calendar
    @ViewBuilder
    private func dayView(for day: Date) -> some View {
        let isToday = Calendar.current.isDateInToday(day)
        let count = taskCount(for: day)

        VStack(spacing: 4) {
            Text(day.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .white : .secondary)

            Text(day.formatted(.dateTime.day()))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(isToday ? .white : .primary)

            Spacer()

            HStack(spacing: 4) {
                if count > 0 { Circle().frame(width: 5, height: 5) }
                if count > 2 { Circle().frame(width: 5, height: 5) }
                if count > 4 { Circle().frame(width: 5, height: 5) }
            }
            .foregroundColor(isToday ? .white.opacity(0.7) : .secondary.opacity(0.7))
            .frame(height: 5)
        }
        .padding(8)
        .frame(width: 60, height: 80)
        .background(isToday ? Color.blue : Color(.systemGray6))
        .cornerRadius(12)
    }

    private func fetchCurrentWeek() {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return }

        var weekDays: [Date] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                weekDays.append(day)
            }
        }
        self.currentWeek = weekDays
    }

    private func taskCount(for day: Date) -> Int {
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: day)
        }.count
    }
}

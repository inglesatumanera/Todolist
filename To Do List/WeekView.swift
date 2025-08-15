import SwiftUI

struct WeekView: View {
    @Binding var tasks: [Task]
    @State private var currentWeek: [Date] = []

    var body: some View {
        VStack {
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

        VStack(spacing: 8) {
            Text(day.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .white : .secondary)

            Text(day.formatted(.dateTime.day()))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(isToday ? .white : .primary)
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
}

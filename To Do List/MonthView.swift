import SwiftUI

enum DayStatus {
    case allCompleted, someCompleted, noneCompleted, noTasks
}

struct MonthView: View {
    @Binding var tasks: [Task]
    @State private var date = Date()
    @State private var monthGrid: [Date] = []

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        var symbols = formatter.shortWeekdaySymbols ?? []
        // The symbols array starts with Sunday. If the user's locale starts the week on Monday, we need to adjust.
        if Calendar.current.firstWeekday == 2 { // Monday
            let sunday = symbols.removeFirst()
            symbols.append(sunday)
        }
        return symbols
    }

    var body: some View {
        VStack {
            // Weekday Headers
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // Calendar Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(monthGrid, id: \.self) { day in
                    VStack(spacing: 4) {
                        Text(day.formatted(.dateTime.day()))

                        Circle()
                            .fill(dotColor(for: status(for: day)))
                            .frame(width: 8, height: 8)
                    }
                    .frame(maxWidth: .infinity, minHeight: 40)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .opacity(isDateInCurrentMonth(day) ? 1.0 : 0.4)
                }
            }
            .padding()
        }
        .onAppear {
            generateMonthGrid()
        }
    }

    private func isDateInCurrentMonth(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self.date, toGranularity: .month)
    }

    private func generateMonthGrid() {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else { return }

        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)

        let paddingDays = (firstWeekday - calendar.firstWeekday + 7) % 7

        guard let gridStartDate = calendar.date(byAdding: .day, value: -paddingDays, to: firstOfMonth) else { return }

        var gridDates: [Date] = []
        let numberOfCells = 42 // 6 weeks * 7 days
        for i in 0..<numberOfCells {
            if let day = calendar.date(byAdding: .day, value: i, to: gridStartDate) {
                gridDates.append(day)
            }
        }

        self.monthGrid = gridDates
    }

    private func dotColor(for status: DayStatus) -> Color {
        switch status {
        case .allCompleted:
            return .green
        case .someCompleted:
            return .yellow
        case .noneCompleted:
            return .gray
        case .noTasks:
            return .clear
        }
    }

    private func status(for day: Date) -> DayStatus {
        let dayTasks = tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: day)
        }

        if dayTasks.isEmpty {
            return .noTasks
        }

        let completedCount = dayTasks.filter { $0.status == .completed }.count

        if completedCount == 0 {
            return .noneCompleted
        } else if completedCount == dayTasks.count {
            return .allCompleted
        } else {
            return .someCompleted
        }
    }
}

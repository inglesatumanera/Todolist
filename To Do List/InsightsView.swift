import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()

    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Weekly Triggers")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(viewModel.weekDays.indices, id: \.self) { index in
                        VStack {
                            Text(daysOfWeek[index])
                                .font(.caption)

                            let day = viewModel.weekDays[index]
                            let trigger = viewModel.weeklySummary[day] ?? ""

                            Rectangle()
                                .fill(colorFor(trigger: trigger))
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                                .overlay(
                                    Text(trigger.prefix(1))
                                        .foregroundColor(.white)
                                        .font(.caption)
                                )
                        }
                    }
                }
                .padding()

                Divider()

                VStack(alignment: .leading) {
                    Text("Legend")
                        .font(.headline)
                    HStack {
                        Rectangle().fill(colorFor(trigger: "Stressed")).frame(width: 20, height: 20)
                        Text("Stressed")
                    }
                    HStack {
                        Rectangle().fill(colorFor(trigger: "Tired")).frame(width: 20, height: 20)
                        Text("Tired")
                    }
                    HStack {
                        Rectangle().fill(colorFor(trigger: "Bored")).frame(width: 20, height: 20)
                        Text("Bored")
                    }
                    HStack {
                        Rectangle().fill(colorFor(trigger: "Social")).frame(width: 20, height: 20)
                        Text("Social")
                    }
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Insights")
            .onAppear {
                viewModel.loadSummary()
            }
        }
    }

    private func colorFor(trigger: String) -> Color {
        switch trigger {
        case "Stressed": return .red
        case "Tired": return .blue
        case "Bored": return .purple
        case "Social": return .orange
        default: return .gray.opacity(0.2)
        }
    }
}

class InsightsViewModel: ObservableObject {
    @Published var weeklySummary: [Date: String] = [:]
    @Published var weekDays: [Date] = []

    private let healthDataManager = HealthDataManager.shared

    init() {
        generateWeekDays()
    }

    func loadSummary() {
        self.weeklySummary = healthDataManager.getWeeklyTriggerSummary()
    }

    private func generateWeekDays() {
        let calendar = Calendar.current
        let today = Date()
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return
        }

        var days: [Date] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
                days.append(day)
            }
        }
        self.weekDays = days
    }
}

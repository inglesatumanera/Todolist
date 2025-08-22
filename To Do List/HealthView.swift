import SwiftUI

struct HealthView: View {
    @State private var healthLogs: [HealthLog] = []
    @State private var todayLog: HealthLog = HealthLog(id: Date()) // Default empty log for today

    // Water goal in glasses
    private let waterGoal = 8
    private let dailyGoal = 30

    private var currentScore: Int {
        var score = 0
        score += todayLog.waterIntake
        if todayLog.didEatClean { score += 10 }
        if todayLog.hadNoJunkFood { score += 5 }
        if todayLog.hadNoSugaryDrinks { score += 5 }
        if todayLog.weight != nil { score += 2 }
        return score
    }

    private var recentGoalsMet: Int {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return healthLogs.filter { log in
            log.id >= sevenDaysAgo && log.dailyGoalMet
        }.count
    }

    var body: some View {
        NavigationView {
            Form {
                // Cheat Meal Section
                if recentGoalsMet >= 6 {
                    Section(header: Text("Rewards")) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Cheat Meal Unlocked!")
                                .font(.headline)
                        }
                    }
                }

                // Daily Goal Progress Section
                Section(header: Text("Daily Goal Progress")) {
                    VStack {
                        ProgressView(value: Double(currentScore), total: Double(dailyGoal))
                            .progressViewStyle(LinearProgressViewStyle())
                        Text("\(currentScore) / \(dailyGoal) Points")
                    }
                    .padding()
                }

                // Water Intake Section
                Section(header: Text("Water Intake")) {
                    VStack {
                        CircularProgressBar(progress: Double(todayLog.waterIntake) / Double(waterGoal))
                            .frame(width: 150, height: 150)
                            .padding()

                        Text("\(todayLog.waterIntake) / \(waterGoal) glasses")

                        HStack {
                            Button(action: {
                                if todayLog.waterIntake > 0 {
                                    todayLog.waterIntake -= 1
                                    saveLog()
                                }
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title)
                            }
                            Spacer()
                            Button(action: {
                                todayLog.waterIntake += 1
                                saveLog()
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Weight Section
                Section(header: Text("Weight")) {
                    HStack {
                        Text("Today's Weight:")
                        TextField("kg", value: $todayLog.weight, format: .number)
                            .keyboardType(.decimalPad)
                            .onChange(of: todayLog.weight) { _ in saveLog() }
                    }
                }

                // Dietary Choices Section
                Section(header: Text("Dietary Choices")) {
                    Toggle("Ate Clean", isOn: $todayLog.didEatClean)
                        .onChange(of: todayLog.didEatClean) { _ in saveLog() }
                    Toggle("No Junk Food", isOn: $todayLog.hadNoJunkFood)
                        .onChange(of: todayLog.hadNoJunkFood) { _ in saveLog() }
                    Toggle("No Sugary Drinks", isOn: $todayLog.hadNoSugaryDrinks)
                        .onChange(of: todayLog.hadNoSugaryDrinks) { _ in saveLog() }
                }
            }
            .navigationTitle("Health Hub")
            .onAppear(perform: loadLogForToday)
        }
    }

    private func loadLogForToday() {
        healthLogs = PersistenceManager.loadHealthLogs()
        if let log = healthLogs.first(where: { Calendar.current.isDateInToday($0.id) }) {
            todayLog = log
        } else {
            let newLog = HealthLog(id: Date())
            todayLog = newLog
            healthLogs.append(newLog)
            PersistenceManager.saveHealthLogs(healthLogs)
        }
    }

    private func saveLog() {
        if let index = healthLogs.firstIndex(where: { Calendar.current.isDateInToday($0.id) }) {
            // before saving, check if the goal is met
            if currentScore >= dailyGoal {
                todayLog.dailyGoalMet = true
            } else {
                todayLog.dailyGoalMet = false
            }
            healthLogs[index] = todayLog
        } else {
            healthLogs.append(todayLog)
        }
        PersistenceManager.saveHealthLogs(healthLogs)
    }
}

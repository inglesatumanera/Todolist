import Foundation

class HealthDataManager {
    static let shared = HealthDataManager()

    private var dailyLogs: [Date: DailyHealthLog] = [:]
    private var habits: [Habit] = []
    private var negativeHabitLogs: [NegativeHabitLog] = []
    private var ringAssignments: [String: UUID] = [:]

    private init() {
        loadData()
    }

    func getLogForToday() -> DailyHealthLog {
        let today = Calendar.current.startOfDay(for: Date())
        if let log = dailyLogs[today] {
            return log
        } else {
            let newLog = DailyHealthLog(date: today)
            dailyLogs[today] = newLog
            return newLog
        }
    }

    func getHabits() -> [Habit] {
        return habits
    }

    func getNegativeHabitLogs() -> [NegativeHabitLog] {
        return negativeHabitLogs
    }

    func getRingAssignments() -> [String: UUID] {
        return ringAssignments
    }

    func update(log: DailyHealthLog) {
        let day = Calendar.current.startOfDay(for: log.date)
        dailyLogs[day] = log
        saveData()
    }

    func update(habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habit

            if updatedHabit.isCompleted && !habits[index].isCompleted {
                if let lastCompletion = habits[index].lastCompletionDate,
                   Calendar.current.isDateInYesterday(lastCompletion) {
                    updatedHabit.streak = habits[index].streak + 1
                } else {
                    updatedHabit.streak = 1
                }
                updatedHabit.lastCompletionDate = Date()
            }

            habits[index] = updatedHabit
            saveData()
        }
    }

    func add(habit: Habit) {
        habits.append(habit)
        saveData()
    }

    func addNegativeHabitLog(habitId: UUID, feeling: String, location: String) {
        let newLog = NegativeHabitLog(id: UUID(), habitId: habitId, date: Date(), feeling: feeling, location: location)
        negativeHabitLogs.append(newLog)
        saveData()
    }

    func assignHabit(_ habitId: UUID, to ringIdentifier: String) {
        ringAssignments[ringIdentifier] = habitId
        saveData()
    }

    func getWeeklyTriggerSummary() -> [Date: String] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: today) else { return [:] }

        let recentLogs = negativeHabitLogs.filter { $0.date >= weekAgo }

        let groupedByDay = Dictionary(grouping: recentLogs) { log -> Date in
            return calendar.startOfDay(for: log.date)
        }

        var summary: [Date: String] = [:]

        for (day, logs) in groupedByDay {
            let feelings = logs.map { $0.feeling }
            let locations = logs.map { $0.location }

            let allTriggers = feelings + locations

            let counts = allTriggers.reduce(into: [:]) { counts, trigger in
                counts[trigger, default: 0] += 1
            }

            if let mostFrequent = counts.max(by: { $0.value < $1.value })?.key {
                summary[day] = mostFrequent
            }
        }

        return summary
    }

    private func loadData() {
        self.dailyLogs = PersistenceManager.loadDailyHealthLogs()
        self.habits = PersistenceManager.loadHabits()
        self.negativeHabitLogs = PersistenceManager.loadNegativeHabitLogs()
        self.ringAssignments = PersistenceManager.loadRingAssignments()

        if self.habits.isEmpty {
            self.habits = [
                Habit(name: "Took my vitamins"),
                Habit(name: "Went to bed on time")
            ]
        }
    }

    private func saveData() {
        PersistenceManager.saveDailyHealthLogs(dailyLogs)
        PersistenceManager.saveHabits(habits)
        PersistenceManager.saveNegativeHabitLogs(negativeHabitLogs)
        PersistenceManager.saveRingAssignments(ringAssignments)
    }
}

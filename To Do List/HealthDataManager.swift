import Foundation

class HealthDataManager {
    static let shared = HealthDataManager()

    private var dailyLogs: [Date: DailyHealthLog] = [:]
    private var habits: [Habit] = []

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

    func update(log: DailyHealthLog) {
        let day = Calendar.current.startOfDay(for: log.date)
        dailyLogs[day] = log
        saveData()
    }

    func update(habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            var updatedHabit = habit

            // Only update streak logic when the habit is being marked as complete
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

    private func loadData() {
        self.dailyLogs = PersistenceManager.loadDailyHealthLogs()
        self.habits = PersistenceManager.loadHabits()

        // Create some default habits if there are none
        if self.habits.isEmpty {
            self.habits = [
                Habit(id: UUID(), name: "Took my vitamins"),
                Habit(id: UUID(), name: "Went to bed on time")
            ]
        }
    }

    private func saveData() {
        PersistenceManager.saveDailyHealthLogs(dailyLogs)
        PersistenceManager.saveHabits(habits)
    }
}

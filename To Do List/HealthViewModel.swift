import Foundation
import Combine

class HealthViewModel: ObservableObject {
    @Published var dailyLog: DailyHealthLog
    @Published var habits: [Habit]

    private var healthDataManager = HealthDataManager.shared

    init() {
        self.dailyLog = healthDataManager.getLogForToday()
        self.habits = healthDataManager.getHabits()
    }

    func updateLog() {
        healthDataManager.update(log: dailyLog)
    }

    func updateHabit(habit: Habit) {
        healthDataManager.update(habit: habit)
    }

    func addHabit(habit: Habit) {
        healthDataManager.add(habit: habit)
        self.habits = healthDataManager.getHabits()
    }

    func logNegativeHabit(habitId: UUID, feeling: String, location: String) {
        healthDataManager.addNegativeHabitLog(habitId: habitId, feeling: feeling, location: location)
    }
}

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
}

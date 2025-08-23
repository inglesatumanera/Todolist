import Foundation

struct PersistenceManager {
    static private var tasksFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("tasks.json")
    }

    static private var userFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("userData.json")
    }

    static func loadTasks() -> [Task] {
        if let data = try? Data(contentsOf: tasksFileUrl) {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
                return decodedTasks
            }
        }
        return []
    }

    static func saveTasks(_ tasks: [Task]) {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            try? encodedData.write(to: tasksFileUrl)
        }
    }

    static func saveUserData(_ userData: UserData?) {
        if let userData = userData, let encodedData = try? JSONEncoder().encode(userData) {
            try? encodedData.write(to: userFileUrl)
        }
    }

    static func loadUserData() -> UserData? {
        if let data = try? Data(contentsOf: userFileUrl) {
            if let decodedUserData = try? JSONDecoder().decode(UserData.self, from: data) {
                return decodedUserData
            }
        }
        return nil
    }

    static func isOnboardingComplete() -> Bool {
        return FileManager.default.fileExists(atPath: userFileUrl.path)
    }

    static private var routinesFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("routines.json")
    }

    static func loadRoutines() -> [Routine] {
        if let data = try? Data(contentsOf: routinesFileUrl) {
            if let decodedRoutines = try? JSONDecoder().decode([Routine].self, from: data) {
                return decodedRoutines
            }
        }
        return []
    }

    static func saveRoutines(_ routines: [Routine]) {
        if let encodedData = try? JSONEncoder().encode(routines) {
            try? encodedData.write(to: routinesFileUrl)
        }
    }

    static private var dailyHealthLogsFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("dailyHealthLogs.json")
    }

    static func loadDailyHealthLogs() -> [Date: DailyHealthLog] {
        if let data = try? Data(contentsOf: dailyHealthLogsFileUrl) {
            if let decodedLogs = try? JSONDecoder().decode([Date: DailyHealthLog].self, from: data) {
                return decodedLogs
            }
        }
        return [:]
    }

    static func saveDailyHealthLogs(_ logs: [Date: DailyHealthLog]) {
        if let encodedData = try? JSONEncoder().encode(logs) {
            try? encodedData.write(to: dailyHealthLogsFileUrl)
        }
    }

    static private var habitsFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("habits.json")
    }

    static func loadHabits() -> [Habit] {
        if let data = try? Data(contentsOf: habitsFileUrl) {
            if let decodedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
                return decodedHabits
            }
        }
        return []
    }

    static func saveHabits(_ habits: [Habit]) {
        if let encodedData = try? JSONEncoder().encode(habits) {
            try? encodedData.write(to: habitsFileUrl)
        }
    }

    static private var negativeHabitLogsFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("negativeHabitLogs.json")
    }

    static func loadNegativeHabitLogs() -> [NegativeHabitLog] {
        if let data = try? Data(contentsOf: negativeHabitLogsFileUrl) {
            if let decodedLogs = try? JSONDecoder().decode([NegativeHabitLog].self, from: data) {
                return decodedLogs
            }
        }
        return []
    }

    static func saveNegativeHabitLogs(_ logs: [NegativeHabitLog]) {
        if let encodedData = try? JSONEncoder().encode(logs) {
            try? encodedData.write(to: negativeHabitLogsFileUrl)
        }
    }

    static private var ringAssignmentsFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("ringAssignments.json")
    }

    static func loadRingAssignments() -> [String: UUID] {
        if let data = try? Data(contentsOf: ringAssignmentsFileUrl) {
            if let decodedAssignments = try? JSONDecoder().decode([String: UUID].self, from: data) {
                return decodedAssignments
            }
        }
        return [:]
    }

    static func saveRingAssignments(_ assignments: [String: UUID]) {
        if let encodedData = try? JSONEncoder().encode(assignments) {
            try? encodedData.write(to: ringAssignmentsFileUrl)
        }
    }
}

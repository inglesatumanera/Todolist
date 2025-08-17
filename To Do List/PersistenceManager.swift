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
}

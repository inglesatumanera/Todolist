import Foundation

struct PersistenceManager {
    static private var tasksFileUrl: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("tasks.json")
    }

    static func loadTasks() -> [Task] {
        if let data = try? Data(contentsOf: tasksFileUrl) {
            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
                return decodedTasks
            }
        }
        return [] // Return an empty array if loading fails
    }

    static func saveTasks(_ tasks: [Task]) {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            try? encodedData.write(to: tasksFileUrl)
        }
    }
}

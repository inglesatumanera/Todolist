import Foundation
import UniformTypeIdentifiers

// Enum to distinguish between a simple task and a project
enum TaskType: Codable, Equatable {
    case simple
    case project
}


struct Task: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var type: TaskType // New
    var status: TaskStatus
    var subCategoryID: UUID?
    var dueDate: Date?
    var subtasks: [Task]? // New: An optional array of sub-tasks
    var completionDate: Date?
}

enum TaskStatus: Codable, Equatable {
    case todo
    case inProgress
    case completed
}

extension Task: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .toDoItem)
    }
}

extension UTType {
    static var toDoItem: UTType { UTType(exportedAs: "com.ralph-learning.ToDoList.toDoItem") }
}

import Foundation
import UniformTypeIdentifiers
import CoreTransferable


enum TaskType: Codable, Equatable {
    case simple
    case project
}

enum TaskCategory: String, CaseIterable, Identifiable, Codable, Equatable {
    case founderCeo = "Founder/CEO"
    case technology = "Technology"
    case youtubeChannel = "YouTube Channel"
    case tiktokContent = "TikTok Content"
    case facebookCommunity = "Facebook Community"
    case personal = "Personal"
    case healthWellness = "Health & Wellness"
    case familyEvents = "Family & Events"
    case sonActivities = "Son's Activities"

    var id: String { self.rawValue }

    var parent: ParentCategory {
        switch self {
        case .founderCeo, .technology, .youtubeChannel, .tiktokContent, .facebookCommunity:
            return .business
        case .personal, .healthWellness:
            return .personal
        case .familyEvents, .sonActivities:
            return .family
        }
    }
}

enum ParentCategory: String, CaseIterable, Identifiable, Codable, Equatable {
    case business = "Business"
    case personal = "Personal"
    case home = "Home"
    case family = "Family"
    
    var id: String { self.rawValue }
}

struct Task: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var type: TaskType
    var status: TaskStatus
    var category: TaskCategory // Retain for compatibility
    var subCategoryID: UUID? // Your new property
    var dueDate: Date?
    var subtasks: [Task]?
    var completionDate: Date? // Your new property
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

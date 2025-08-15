import Foundation

// Enum to distinguish between a simple task and a project
enum TaskType: Codable, Equatable {
    case simple
    case project
}

enum ParentCategory: String, CaseIterable, Identifiable, Codable, Equatable {
    case business = "Business"
    case personal = "Personal"
    case home = "Home"
    case family = "Family"
    
    var id: String { self.rawValue }
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

struct Task: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var type: TaskType // New
    var status: TaskStatus
    var category: TaskCategory
    var dueDate: Date?
    var subtasks: [Task]? // New: An optional array of sub-tasks
}

enum TaskStatus: Codable, Equatable {
    case todo
    case inProgress
    case completed
}

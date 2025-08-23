import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var isCompleted: Bool = false
    var streak: Int = 0
    var lastCompletionDate: Date?
}

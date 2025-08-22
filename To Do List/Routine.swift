import Foundation

struct Routine: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var icon: String
    var steps: [RoutineStep]
    var streakCount: Int = 0
    var lastCompletionDate: Date?
    var scheduledTime: Date?
}

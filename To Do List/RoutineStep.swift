import Foundation

struct RoutineStep: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var durationInSeconds: Int?
    var isCompleted: Bool = false
}

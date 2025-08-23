import Foundation

struct Journey: Identifiable, Decodable {
    let id: UUID
    let name: String
    let description: String
    let durationInDays: Int
    let habitTemplates: [Habit]
}

import Foundation

struct NegativeHabitLog: Identifiable, Codable {
    let id: UUID
    let habitId: UUID
    let date: Date
    let feeling: String
    let location: String
}

import Foundation

struct UserData: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var goals: [Goal]
}

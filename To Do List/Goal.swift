import Foundation

struct Goal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
}

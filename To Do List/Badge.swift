import Foundation

struct Badge: Identifiable, Codable, Equatable {
    let id: String // Use a string for the ID to make it easy to identify
    let name: String
    let description: String
    let icon: String
}

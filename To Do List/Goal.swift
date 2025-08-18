import Foundation

struct Goal: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var imageData: Data?
    var linkedCategoryID: UUID?
}

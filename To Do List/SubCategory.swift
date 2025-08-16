import Foundation

struct SubCategory: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var parentCategoryID: UUID
}

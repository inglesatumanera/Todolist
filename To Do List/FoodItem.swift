import Foundation

struct FoodItem: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var category: String // "Protein", "Carbs", "Fat"
    var grams: Double
    var calories: Int
}

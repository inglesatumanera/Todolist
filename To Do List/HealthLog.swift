import Foundation

struct HealthLog: Identifiable, Codable, Equatable {
    var id: Date // Using the date as the unique identifier for a daily log
    var weight: Double?
    var waterIntake: Int = 0 // in glasses
    var didEatClean: Bool = false
    var hadNoJunkFood: Bool = false
    var hadNoSugaryDrinks: Bool = false
    var dailyGoalMet: Bool = false
}

import Foundation

struct DailyHealthLog: Codable, Equatable {
    var date: Date
    var activityMinutes: Int = 0
    var waterIntake: Int = 0 // in glasses
    var mindfulnessMinutes: Int = 0

    // New properties
    var currentWeight: Double = 0
    var calorieGoal: Int = 2000
    var proteinGoal: Int = 150
    var carbsGoal: Int = 200
    var fatGoal: Int = 60
    var foodLog: [FoodItem] = []

    // Computed properties for macro totals
    var totalProtein: Double {
        foodLog.filter { $0.category == "Protein" }.reduce(0) { $0 + $1.grams }
    }

    var totalCarbs: Double {
        foodLog.filter { $0.category == "Carbs" }.reduce(0) { $0 + $1.grams }
    }

    var totalFat: Double {
        foodLog.filter { $0.category == "Fat" }.reduce(0) { $0 + $1.grams }
    }

    var caloriesConsumed: Int {
        foodLog.reduce(0) { $0 + $1.calories }
    }
}

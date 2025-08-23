import Foundation

struct DailyHealthLog: Codable, Equatable {
    var date: Date
    var activityMinutes: Int = 0
    var waterIntake: Int = 0 // in glasses
    var mindfulnessMinutes: Int = 0
}

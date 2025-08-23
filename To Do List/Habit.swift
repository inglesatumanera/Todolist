import Foundation

// Enum to define the type of habit
enum HabitType: String, Codable, CaseIterable {
    case yesNo = "Yes/No"
    case target = "Target Goal"
}

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var type: HabitType
    var isNegative: Bool = false

    // Properties for Yes/No type (can also be used for negative habits)
    var isCompleted: Bool = false

    // Properties for Target type
    var targetValue: Int?
    var currentValue: Int = 0
    var targetUnit: String?

    // Streak tracking
    var streak: Int = 0
    var lastCompletionDate: Date?

    // Initializer for a simple Yes/No habit
    init(id: UUID = UUID(), name: String, type: HabitType = .yesNo, isNegative: Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.isNegative = isNegative
    }

    // Initializer for a Target goal habit
    init(id: UUID = UUID(), name: String, type: HabitType = .target, targetValue: Int, targetUnit: String) {
        self.id = id
        self.name = name
        self.type = type
        self.targetValue = targetValue
        self.targetUnit = targetUnit
    }
}

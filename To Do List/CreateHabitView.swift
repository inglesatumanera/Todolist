import SwiftUI

struct CreateHabitView: View {
    @Environment(\.dismiss) var dismiss
    var onSave: (Habit) -> Void

    @State private var name: String = ""
    @State private var type: HabitType = .yesNo
    @State private var targetValue: String = ""
    @State private var targetUnit: String = ""
    @State private var isNegative: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit Details")) {
                    TextField("Habit Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(HabitType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    Toggle("Negative Habit", isOn: $isNegative)
                }

                if type == .target {
                    Section(header: Text("Target Goal")) {
                        TextField("Target Value", text: $targetValue)
                            .keyboardType(.numberPad)
                        TextField("Unit (e.g., pages, steps)", text: $targetUnit)
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func saveHabit() {
        var newHabit: Habit
        if type == .target {
            newHabit = Habit(
                name: name,
                type: .target,
                targetValue: Int(targetValue) ?? 0,
                targetUnit: targetUnit
            )
        } else {
            newHabit = Habit(name: name, type: .yesNo, isNegative: isNegative)
        }
        onSave(newHabit)
    }
}

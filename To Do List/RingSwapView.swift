import SwiftUI

struct RingSwapView: View {
    let habits: [Habit]
    var onSelect: (Habit) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(habits.filter { $0.type == .target }) { habit in
                    Button(action: {
                        onSelect(habit)
                        dismiss()
                    }) {
                        Text(habit.name)
                    }
                }
            }
            .navigationTitle("Select a Habit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

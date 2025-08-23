import SwiftUI

struct HabitRowView: View {
    @Binding var habit: Habit
    var onUpdate: (Habit) -> Void
    var onLogNegative: (UUID, String, String) -> Void = { _, _, _ in }

    @State private var showingContextLogger = false

    var body: some View {
        HStack {
            if habit.isNegative {
                Text("Did you \(habit.name) today?")
                Spacer()
                Button("Yes") {
                    showingContextLogger = true
                }
                Button("No") {
                    var updatedHabit = habit
                    updatedHabit.isCompleted = true
                    onUpdate(updatedHabit)
                }
            } else {
                Text(habit.name)
                Spacer()

                if habit.type == .target {
                    Text("\(habit.currentValue)/\(habit.targetValue ?? 0) \(habit.targetUnit ?? "")")
                }

                Text("Streak: \(habit.streak)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Button(action: {
                    var updatedHabit = habit
                    updatedHabit.isCompleted.toggle()
                    onUpdate(updatedHabit)
                }) {
                    Image(systemName: habit.isCompleted ? "checkmark.square.fill" : "square")
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
        .sheet(isPresented: $showingContextLogger) {
            ContextLoggingView(habit: habit) { feeling, location in
                onLogNegative(habit.id, feeling, location)
            }
        }
    }
}

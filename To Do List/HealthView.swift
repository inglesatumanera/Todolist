import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @State private var showingActivityEntry = false
    @State private var showingMindfulnessEntry = false

    // Goals
    private let activityGoal = 60 // minutes
    private let waterGoal = 8 // glasses
    private let mindfulnessGoal = 10 // minutes

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Rings of Progress
                    HStack(spacing: 20) {
                        Button(action: { showingActivityEntry = true }) {
                            ProgressRingView(
                                progress: Double(viewModel.dailyLog.activityMinutes) / Double(activityGoal),
                                color: .orange,
                                icon: "figure.walk"
                            )
                        }

                        VStack {
                            ProgressRingView(
                                progress: Double(viewModel.dailyLog.waterIntake) / Double(waterGoal),
                                color: .blue,
                                icon: "drop.fill"
                            )
                            HStack {
                                Button(action: {
                                    viewModel.dailyLog.waterIntake -= 1
                                    viewModel.updateLog()
                                }) { Image(systemName: "minus") }
                                Text("\(viewModel.dailyLog.waterIntake)")
                                Button(action: {
                                    viewModel.dailyLog.waterIntake += 1
                                    viewModel.updateLog()
                                }) { Image(systemName: "plus") }
                            }
                            .font(.caption)
                        }

                        Button(action: { showingMindfulnessEntry = true }) {
                            ProgressRingView(
                                progress: Double(viewModel.dailyLog.mindfulnessMinutes) / Double(mindfulnessGoal),
                                color: .purple,
                                icon: "brain.head.profile"
                            )
                        }
                    }
                    .padding()

                    // Habit List
                    VStack(alignment: .leading) {
                        Text("Today's Habits")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        List {
                            ForEach($viewModel.habits) { $habit in
                                HStack {
                                    Text(habit.name)
                                    Spacer()
                                    Text("Streak: \(habit.streak)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Button(action: {
                                        habit.isCompleted.toggle()
                                        viewModel.updateHabit(habit: habit)
                                    }) {
                                        Image(systemName: habit.isCompleted ? "checkmark.square.fill" : "square")
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                        .frame(height: 200) // Temporary fixed height
                    }
                }
            }
            .navigationTitle("Health Hub")
            .sheet(isPresented: $showingActivityEntry) {
                ManualEntryView(value: $viewModel.dailyLog.activityMinutes, title: "Log Activity")
                    .onDisappear(perform: viewModel.updateLog)
            }
            .sheet(isPresented: $showingMindfulnessEntry) {
                ManualEntryView(value: $viewModel.dailyLog.mindfulnessMinutes, title: "Log Mindfulness")
                    .onDisappear(perform: viewModel.updateLog)
            }
        }
    }
}

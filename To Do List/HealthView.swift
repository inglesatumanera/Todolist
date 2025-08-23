import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @State private var showingActivityEntry = false
    @State private var showingMindfulnessEntry = false
    @State private var showingCreateHabit = false
    @State private var showingRingSwap = false
    @State private var editingRingPosition: RingPosition?

    enum RingPosition {
        case left, middle, right
    }

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
                        ProgressRingView(
                            progress: Double(viewModel.dailyLog.activityMinutes) / Double(activityGoal),
                            color: .orange,
                            icon: "figure.walk"
                        )
                        .onTapGesture { showingActivityEntry = true }
                        .onLongPressGesture {
                            editingRingPosition = .left
                            showingRingSwap = true
                        }

                        VStack {
                            ProgressRingView(
                                progress: Double(viewModel.dailyLog.waterIntake) / Double(waterGoal),
                                color: .blue,
                                icon: "drop.fill"
                            )
                            HStack {
                                Button(action: {
                                    if viewModel.dailyLog.waterIntake > 0 {
                                        viewModel.dailyLog.waterIntake -= 1
                                        viewModel.updateLog()
                                    }
                                }) { Image(systemName: "minus") }
                                Text("\(viewModel.dailyLog.waterIntake)")
                                Button(action: {
                                    viewModel.dailyLog.waterIntake += 1
                                    viewModel.updateLog()
                                }) { Image(systemName: "plus") }
                            }
                            .font(.caption)
                        }

                        ProgressRingView(
                            progress: Double(viewModel.dailyLog.mindfulnessMinutes) / Double(mindfulnessGoal),
                            color: .purple,
                            icon: "brain.head.profile"
                        )
                        .onTapGesture { showingMindfulnessEntry = true }
                        .onLongPressGesture {
                            editingRingPosition = .right
                            showingRingSwap = true
                        }
                    }
                    .padding()

                    // Habit List
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Today's Habits")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: { showingCreateHabit = true }) {
                                Image(systemName: "plus")
                            }
                        }
                        .padding(.horizontal)

                        List {
                            ForEach($viewModel.habits) { $habit in
                                HabitRowView(habit: $habit, onUpdate: viewModel.updateHabit, onLogNegative: viewModel.logNegativeHabit)
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
            .sheet(isPresented: $showingCreateHabit) {
                CreateHabitView { newHabit in
                    viewModel.addHabit(habit: newHabit)
                }
            }
            .sheet(isPresented: $showingRingSwap) {
                // Placeholder for ring swap view
                Text("Select a Target Goal to display here.")
            }
        }
    }
}

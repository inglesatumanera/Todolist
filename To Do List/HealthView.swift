import SwiftUI

struct HealthView: View {
    @StateObject private var viewModel = HealthViewModel()
    @State private var showingActivityEntry = false
    @State private var showingMindfulnessEntry = false
    @State private var showingCreateHabit = false
    @State private var showingRingSwap = false
    @State private var editingRingPosition: RingPosition?

    enum RingPosition: String {
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
                        ringView(for: .left)
                        ringView(for: .middle)
                        ringView(for: .right)
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

                    Section {
                        NavigationLink(destination: InsightsView()) {
                            Text("View Your Insights")
                        }
                    }
                }
            }
            .navigationTitle("Health Hub")
            .sheet(isPresented: $showingCreateHabit) {
                CreateHabitView { newHabit in
                    viewModel.addHabit(habit: newHabit)
                }
            }
            .sheet(isPresented: $showingRingSwap) {
                RingSwapView(habits: viewModel.habits) { habit in
                    if let position = editingRingPosition {
                        viewModel.assignHabit(habit, to: position.rawValue)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func ringView(for position: RingPosition) -> some View {
        let habitId = viewModel.ringAssignments[position.rawValue]
        let habit = viewModel.habits.first(where: { $0.id == habitId })

        if let habit = habit, let targetValue = habit.targetValue {
            // Custom Habit Ring
            ProgressRingView(
                progress: Double(habit.currentValue) / Double(targetValue),
                color: .green, // Custom color
                icon: "star.fill" // Custom icon
            )
            .onLongPressGesture {
                editingRingPosition = position
                showingRingSwap = true
            }
        } else {
            // Default Rings
            switch position {
            case .left:
                ProgressRingView(
                    progress: Double(viewModel.dailyLog.activityMinutes) / Double(activityGoal),
                    color: .orange,
                    icon: "figure.walk"
                )
                .onTapGesture { showingActivityEntry = true }
                .onLongPressGesture {
                    editingRingPosition = position
                    showingRingSwap = true
                }
                .sheet(isPresented: $showingActivityEntry) {
                    ManualEntryView(value: $viewModel.dailyLog.activityMinutes, title: "Log Activity")
                        .onDisappear(perform: viewModel.updateLog)
                }
            case .middle:
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
            case .right:
                ProgressRingView(
                    progress: Double(viewModel.dailyLog.mindfulnessMinutes) / Double(mindfulnessGoal),
                    color: .purple,
                    icon: "brain.head.profile"
                )
                .onTapGesture { showingMindfulnessEntry = true }
                .onLongPressGesture {
                    editingRingPosition = position
                    showingRingSwap = true
                }
                .sheet(isPresented: $showingMindfulnessEntry) {
                    ManualEntryView(value: $viewModel.dailyLog.mindfulnessMinutes, title: "Log Mindfulness")
                        .onDisappear(perform: viewModel.updateLog)
                }
            }
        }
    }
}

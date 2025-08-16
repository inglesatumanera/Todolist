import SwiftUI
import UniformTypeIdentifiers

struct DayDropDelegate: DropDelegate {
    let day: Date
    @Binding var tasks: [Task]

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.toDoItem]).first else {
            return false
        }

        item.loadTransferable(type: Task.self) { result in
            switch result {
            case .success(let droppedTask):
                DispatchQueue.main.async {
                    if let index = self.tasks.firstIndex(where: { $0.id == droppedTask.id }) {
                        self.tasks[index].dueDate = self.day
                    }
                }
            case .failure(let error):
                print("Error loading dropped item: \(error)")
            }
        }

        return true
    }
}

struct WeekView: View {
    @Binding var tasks: [Task]
    @State private var currentWeek: [Date] = []
    @State private var selectedDate: Date = Date()
    @State private var needsReview: Bool = false
    @State private var showReviewSheet: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            if needsReview {
                Button(action: { showReviewSheet = true }) {
                    HStack {
                        Image(systemName: "text.badge.star")
                        Text("Review Last Week")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            WeeklyFocusView(date: Date())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(currentWeek, id: \.self) { day in
                        dayView(for: day)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 100)

            // Tasks for selected day
            List {
                ForEach(tasksForSelectedDay) { task in
                    // Need a binding to the task for TaskCard
                    if let binding = binding(for: task) {
                        TaskCard(task: binding, allTasks: $tasks)
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: 200) // Give it a fixed height for now

            // Task Hub
            VStack(alignment: .leading) {
                Text("Task Hub")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if unscheduledTasks.isEmpty {
                    Text("No unscheduled tasks. Great job!")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List {
                        ForEach(unscheduledTasks) { task in
                            Text(task.title)
                                .padding()
                                .onDrag {
                                    return task
                                }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear {
            fetchCurrentWeek()
            checkNeedsReview()
        }
        .sheet(isPresented: $showReviewSheet, onDismiss: {
            // Mark the prompt as seen for this week so it doesn't appear again.
            WeeklyReviewManager.shared.markReviewAsSeen(for: Date())
            self.needsReview = false
        }) {
            WeeklyReviewFlowView(tasks: $tasks) {
                // This closure is called when the user taps "Finish Review"
                self.showReviewSheet = false
            }
        }
    }

    private func checkNeedsReview() {
        // A review is needed if the user hasn't seen the prompt for last week's review yet.
        // We don't check if they *filled it out*, only if they've seen the prompt.
        // This prevents the prompt from reappearing if they dismiss the sheet.
        self.needsReview = !WeeklyReviewManager.shared.hasSeenReviewPrompt(for: Date())
    }

    // A view for a single day in the calendar
    @ViewBuilder
    private func dayView(for day: Date) -> some View {
        let isToday = Calendar.current.isDateInToday(day)
        let isSelected = Calendar.current.isDate(day, inSameDayAs: selectedDate)
        let count = taskCount(for: day)

        VStack(spacing: 4) {
            Text(day.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isToday ? .white : .secondary)

            Text(day.formatted(.dateTime.day()))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(isToday ? .white : .primary)

            Spacer()

            HStack(spacing: 4) {
                if count > 0 { Circle().frame(width: 5, height: 5) }
                if count > 2 { Circle().frame(width: 5, height: 5) }
                if count > 4 { Circle().frame(width: 5, height: 5) }
            }
            .foregroundColor(isToday ? .white.opacity(0.7) : .secondary.opacity(0.7))
            .frame(height: 5)
        }
        .padding(8)
        .frame(width: 60, height: 80)
        .background(isToday ? Color.blue : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            selectedDate = day
        }
        .onDrop(of: [UTType.toDoItem], delegate: DayDropDelegate(day: day, tasks: $tasks))
    }

    private func fetchCurrentWeek() {
        let calendar = Calendar.current
        let today = Date()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) else { return }

        var weekDays: [Date] = []
        for i in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                weekDays.append(day)
            }
        }
        self.currentWeek = weekDays
    }

    private func taskCount(for day: Date) -> Int {
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: day)
        }.count
    }

    private var unscheduledTasks: [Task] {
        return tasks.filter { $0.dueDate == nil }
    }

    private var tasksForSelectedDay: [Task] {
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDate(dueDate, inSameDayAs: selectedDate)
        }
    }

    private func binding(for task: Task) -> Binding<Task>? {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            return $tasks[index]
        }
        for parentIndex in tasks.indices {
            if let subtaskIndex = tasks[parentIndex].subtasks?.firstIndex(where: { $0.id == task.id }) {
                return Binding(
                    get: { tasks[parentIndex].subtasks![subtaskIndex] },
                    set: { tasks[parentIndex].subtasks![subtaskIndex] = $0 }
                )
            }
        }
        return nil
    }
}

import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData
    @State private var isPastDueExpanded = true
    @State private var taskToReschedule: Binding<Task>?
    @State private var showingRescheduleSheet = false

    var body: some View {
        List {
            // Past Due Section
            if !pastDueTasks.isEmpty {
                DisclosureGroup(isExpanded: $isPastDueExpanded) {
                    ForEach(pastDueTasks) { task in
                        if let binding = binding(for: task) {
                            TaskCard(task: binding, allTasks: $tasks, categoryData: $categoryData)
                                .contextMenu {
                                    Button {
                                        moveTaskToToday(taskBinding: binding)
                                    } label: {
                                        Label("Move to Today", systemImage: "arrow.right.to.square")
                                    }

                                    Button {
                                        taskToReschedule = binding
                                        showingRescheduleSheet = true
                                    } label: {
                                        Label("Reschedule", systemImage: "calendar.badge.plus")
                                    }
                                }
                        }
                    }
                } label: {
                    HStack {
                        Text("Let's catch up!")
                            .font(.headline)
                        Spacer()
                        Text("\(pastDueTasks.count) overdue")
                            .font(.caption)
                    }
                }
            }

            // Today's Tasks Section
            Section(header: Text(todayTasks.isEmpty ? "No Tasks Today!" : "Today's Focus")) {
                ForEach(todayTasks) { task in
                    if let binding = binding(for: task) {
                        TaskCard(task: binding, allTasks: $tasks, categoryData: $categoryData)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .sheet(isPresented: $showingRescheduleSheet) {
            if let taskBinding = taskToReschedule {
                RescheduleView(task: taskBinding)
            }
        }
    }

    private func moveTaskToToday(taskBinding: Binding<Task>) {
        taskBinding.wrappedValue.dueDate = Date()
    }

    private func binding(for task: Task) -> Binding<Task>? {
        // Search in top-level tasks
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            return $tasks[index]
        }
        
        // Search in sub-tasks
        for parentIndex in tasks.indices {
            if let subtaskIndex = tasks[parentIndex].subtasks?.firstIndex(where: { $0.id == task.id }) {
                return Binding(
                    get: {
                        return tasks[parentIndex].subtasks![subtaskIndex]
                    },
                    set: {
                        tasks[parentIndex].subtasks![subtaskIndex] = $0
                    }
                )
            }
        }
        
        return nil
    }

    private func allTasksAndSubtasks() -> [Task] {
        var all = tasks
        for task in tasks {
            if let subtasks = task.subtasks {
                all.append(contentsOf: subtasks)
            }
        }
        return all
    }

    private var todayTasks: [Task] {
        allTasksAndSubtasks().filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate) && task.status != .completed
        }
    }

    private var pastDueTasks: [Task] {
        allTasksAndSubtasks().filter { task in
            guard let dueDate = task.dueDate else { return false }
            return dueDate < Date() && !Calendar.current.isDateInToday(dueDate) && task.status != .completed
        }
    }
    
}

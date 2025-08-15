import SwiftUI

struct TodayView: View {
    @Binding var tasks: [Task]
    @State private var selectedTab: Int = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            // Past Due Tab
            List {
                ForEach(pastDueTasks) { task in
                    if let binding = binding(for: task) {
                        TaskCard(task: binding, allTasks: $tasks)
                            .listRowBackground(Color.red.opacity(0.1))
                    }
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "calendar.badge.minus")
                    Text("Past Due")
                }
            }
            .listStyle(.insetGrouped)
            .tag(0)
            .badge(pastDueTasks.count)
            
            // Due Today Tab
            List {
                ForEach(todayTasks) { task in
                    if let binding = binding(for: task) {
                        TaskCard(task: binding, allTasks: $tasks)
                    }
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("Due Today")
                }
            }
            .listStyle(.insetGrouped)
            .tag(1)
            .badge(todayTasks.count)

            // Tomorrow Tab
            List {
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    let filteredTasks = tomorrowTasks(for: category)
                    if !filteredTasks.isEmpty {
                        Section(header: Text(category.rawValue)) {
                            ForEach(filteredTasks) { task in
                                if let binding = binding(for: task) {
                                    TaskCard(task: binding, allTasks: $tasks)
                                }
                            }
                        }
                    }
                }
            }
            .tabItem {
                VStack {
                    Image(systemName: "calendar.badge.plus")
                    Text("Tomorrow")
                }
            }
            .listStyle(.insetGrouped)
            .tag(2)
            .badge(tomorrowTasksCount)
        }
        .accentColor(.blue)
        .navigationTitle("Upcoming Tasks")
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
    
    private var tomorrowTasksCount: Int {
        allTasksAndSubtasks().filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInTomorrow(dueDate) && task.status != .completed
        }.count
    }

    private func tomorrowTasks(for category: TaskCategory) -> [Task] {
        allTasksAndSubtasks().filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInTomorrow(dueDate) && task.status != .completed && task.category == category
        }
    }
}

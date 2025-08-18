import SwiftUI
import Foundation

struct MainTabView: View {
    // MainTabView should be the source of truth for this data
    @State private var tasks: [Task] = PersistenceManager.loadTasks()
    @State private var categoryData: CategoryManager.CategoryData = CategoryManager.shared.load()
    @State private var userData: UserData?

    var body: some View {
        TabView {
            // TodayView should also be corrected to accept a binding for tasks
            TodayView(tasks: $tasks, categoryData: $categoryData)
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            // HubView now receives all required data as bindings
            HubView(tasks: $tasks, userData: $userData, categoryData: $categoryData)
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
        }
        .onAppear(perform: loadData)
        .onChange(of: tasks) {
            PersistenceManager.saveTasks(tasks)
        }
        .onChange(of: categoryData) {
            CategoryManager.shared.save(categoryData)
        }
        .onChange(of: userData) {
            PersistenceManager.saveUserData(userData)
        }
    }

    private func loadData() {
        self.userData = PersistenceManager.loadUserData()
    }
}

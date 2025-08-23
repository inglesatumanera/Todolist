import SwiftUI
import Foundation

struct AppHomeView: View {
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData
    @State private var userData: UserData?
    @State private var showingGoalsHub = false
    @State private var selectedTab: Int = 1 // Default to To-Do tab

    var body: some View {
        TabView(selection: $selectedTab) {
            RoutinesView()
                .tabItem {
                    Label("Routines", systemImage: "arrow.triangle.2.circlepath")
                }
                .tag(0)

            NavigationView {
                ToDoContainerView(tasks: $tasks, categoryData: $categoryData)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showingGoalsHub = true }) {
                                Image(systemName: "square.grid.2x2")
                            }
                        }
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("To-Do", systemImage: "list.bullet")
            }
            .tag(1)

            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
                .tag(2)
        }
        .sheet(isPresented: $showingGoalsHub) {
            HubView(tasks: $tasks, userData: $userData, categoryData: $categoryData)
        }
        .onAppear {
            self.userData = PersistenceManager.loadUserData()
        }
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
}

import SwiftUI
import Foundation

// Placeholder views to allow the app to compile




struct AppHomeView: View {
    // This view should be the source of truth, so we use @State
    @Binding var tasks: [Task]
     @Binding var categoryData: CategoryManager.CategoryData
    @State private var userData: UserData?
    
    @State private var showingGoalsHub = false

    var body: some View {
        TabView {
            RoutinesView()
                .tabItem {
                    Label("Routines", systemImage: "arrow.triangle.2.circlepath")
                }

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

            HealthView()
                .tabItem {
                    Label("Health", systemImage: "heart.fill")
                }
        }
        .sheet(isPresented: $showingGoalsHub) {
            // The HubView now receives correct bindings
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

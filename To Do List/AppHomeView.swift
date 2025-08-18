import SwiftUI
import Foundation

// Placeholder views to allow the app to compile




struct AppHomeView: View {
    // This view should be the source of truth, so we use @State
    @Binding var tasks: [Task]
     @Binding var categoryData: CategoryManager.CategoryData
    @State private var userData: UserData?
    
    @State private var showingGoalsHub = false

    enum SelectedTab {
        case today, week, month, completed
    }

    @State private var selectedTab: SelectedTab = .today
    @Namespace private var topTabNamespace

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Top Tab Bar
                HStack(spacing: 20) {
                    tabButton(title: "Today", tab: .today)
                    tabButton(title: "Week", tab: .week)
                    tabButton(title: "Month", tab: .month)
                    tabButton(title: "Completed", tab: .completed)
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color(.systemBackground))
                .shadow(radius: 2)

                // View Content
                switch selectedTab {
                case .today:
                    TodayView(tasks: $tasks, categoryData: $categoryData)
                case .week:
                    WeekView(tasks: $tasks, categoryData: $categoryData)
                case .month:
                    MonthView(tasks: $tasks)
                case .completed:
                    CompletedTasksView(tasks: $tasks, categoryData: $categoryData)
                }
            }
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
        .sheet(isPresented: $showingGoalsHub) {
            // The HubView now receives correct bindings
            HubView(tasks: $tasks, userData: $userData, categoryData: $categoryData)
        }
        .onAppear {
            self.userData = PersistenceManager.loadUserData()
        }
        .onChange(of: tasks) { _ in
            PersistenceManager.saveTasks(tasks)
        }
        .onChange(of: categoryData) { _ in
            CategoryManager.shared.save(categoryData)
        }
        .onChange(of: userData) { _ in
            PersistenceManager.saveUserData(userData)
        }
    }

    // Reusable button view for the tab bar
    private func tabButton(title: String, tab: SelectedTab) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .fontWeight(selectedTab == tab ? .bold : .regular)
                    .foregroundColor(selectedTab == tab ? .primary : .secondary)

                if selectedTab == tab {
                    Rectangle()
                        .frame(height: 3)
                        .foregroundColor(.blue)
                        .matchedGeometryEffect(id: "underline", in: topTabNamespace)
                } else {
                    Color.clear.frame(height: 3)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

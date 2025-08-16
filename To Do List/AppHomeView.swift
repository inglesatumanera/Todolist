import SwiftUI

struct AppHomeView: View {
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData
    @State private var showingGoalsHub = false

    // Enum to represent the tabs
    enum SelectedTab {
        case today, week, month
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
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color(.systemBackground))
                .shadow(radius: 2)

                // View Content
                switch selectedTab {
                case .today:
                    TodayView(tasks: $tasks)
                case .week:
                    WeekView(tasks: $tasks)
                case .month:
                    MonthView(tasks: $tasks)
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
        .navigationViewStyle(StackNavigationViewStyle()) // Prevents sidebar on iPad
        .sheet(isPresented: $showingGoalsHub) {
            // The HubView will be the "Goals Hub"
            // It needs to be refactored to use the new data
            // For now, we pass a placeholder binding
            HubView(tasks: $tasks, userData: nil, categoryData: $categoryData)
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
            .contentShape(Rectangle()) // Makes the whole area tappable
        }
        .buttonStyle(PlainButtonStyle())
    }
}

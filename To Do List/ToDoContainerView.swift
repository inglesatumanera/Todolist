import SwiftUI

struct ToDoContainerView: View {
    @Binding var tasks: [Task]
    @Binding var categoryData: CategoryManager.CategoryData

    enum SelectedTab {
        case today, week, month, completed
    }

    @State private var selectedTab: SelectedTab = .today
    @Namespace private var topTabNamespace

    var body: some View {
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
            Spacer()
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

import SwiftUI

struct AppHomeView: View {
    @Binding var tasks: [Task]

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
                    Text("Week View Placeholder")
                        .font(.title)
                        .frame(maxHeight: .infinity)
                case .month:
                    Text("Month View Placeholder")
                        .font(.title)
                        .frame(maxHeight: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    // This is a common trick to use a custom view in the nav bar space
                    // But for now, let's just rely on the custom bar below it.
                    // We can hide the nav bar if needed, but this setup works.
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Prevents sidebar on iPad
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

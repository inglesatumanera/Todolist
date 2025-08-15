import SwiftUI

struct MainTabView: View {
    @Binding var tasks: [Task]
    @State private var userData: UserData?

    var body: some View {
        TabView {
            TodayView(tasks: $tasks)
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            HubView(tasks: $tasks, userData: userData)
                .tabItem {
                    Label("Dashboard", systemImage: "square.grid.2x2.fill")
                }
        }
        .onAppear(perform: loadUserData)
    }

    private func loadUserData() {
        self.userData = PersistenceManager.loadUserData()
    }
}

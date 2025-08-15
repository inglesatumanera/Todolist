import SwiftUI

struct HubView: View {
    @State private var tasks: [Task] = PersistenceManager.loadTasks()
    @State private var showOnboarding = !PersistenceManager.isOnboardingComplete()
    @State private var userData: UserData?

    let gridLayout = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                if let userData = userData {
                    VStack(alignment: .leading) {
                        Text("Hello, \(userData.name)!")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 5)
                        Text("Your Goals:")
                            .font(.headline)
                        ForEach(userData.goals) { goal in
                            Text("• \(goal.title)")
                                .font(.body)
                                .padding(.leading, 8)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding([.horizontal, .bottom])
                }

                // Standalone card for Today's Tasks
                NavigationLink(destination: TodayView(tasks: $tasks)) {
                    HStack {
                        Image(systemName: "checklist.checked")
                            .foregroundColor(.white)
                        Text("Today's Tasks")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                // Grid of Parent Categories
                LazyVGrid(columns: gridLayout, spacing: 16) {
                    ForEach(ParentCategory.allCases) { parent in
                        NavigationLink(destination: SubCategoryView(tasks: $tasks, parent: parent)) {
                            HubCardView(parentCategory: parent)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Dashboard")
        }
        .onAppear(perform: loadUserData)
        .onChange(of: tasks) { _ in
            PersistenceManager.saveTasks(tasks)
        }
        .sheet(isPresented: $showOnboarding, onDismiss: {
            self.userData = PersistenceManager.loadUserData()
        }) {
            OnboardingView(isOnboardingComplete: $showOnboarding)
        }
    }

    private func loadUserData() {
        self.userData = PersistenceManager.loadUserData()
    }
}

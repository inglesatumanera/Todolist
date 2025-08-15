import SwiftUI

struct HubView: View {
    @State private var tasks: [Task] = PersistenceManager.loadTasks()

    let gridLayout = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
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
        .onChange(of: tasks) { _ in
            PersistenceManager.saveTasks(tasks)
        }
    }
}

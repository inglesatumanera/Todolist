import SwiftUI

struct HubView: View {
    @Binding var tasks: [Task]
    var userData: UserData?
    @Binding var categoryData: CategoryManager.CategoryData
    @State private var showingAddCategorySheet = false

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
                
                // Grid of Categories
                LazyVGrid(columns: gridLayout, spacing: 16) {
                    ForEach(categoryData.categories) { category in
                        NavigationLink(destination: SubCategoryView(tasks: $tasks, category: category, subCategories: categoryData.subCategories)) {
                            HubCardView(category: category)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Goals Hub")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCategorySheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onChange(of: tasks) { _ in
            PersistenceManager.saveTasks(tasks)
        }
        .sheet(isPresented: $showingAddCategorySheet) {
            AddCategoryView(categoryData: $categoryData)
        }
    }
}

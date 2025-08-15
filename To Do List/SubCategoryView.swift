import SwiftUI

struct SubCategoryView: View {
    @Binding var tasks: [Task]
    let parent: ParentCategory

    let gridLayout = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 16) {
                ForEach(TaskCategory.allCases.filter { $0.parent == parent }) { subcategory in
                    NavigationLink(destination: ContentView(tasks: $tasks, selectedCategory: subcategory)) {
                        SubcategoryCardView(subcategory: subcategory, taskCount: filteredTasksCount(for: subcategory))
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(parent.rawValue)
    }

    private func filteredTasksCount(for subcategory: TaskCategory) -> Int {
        tasks.filter { $0.category == subcategory }.count
    }
}

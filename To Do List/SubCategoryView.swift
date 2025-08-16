import SwiftUI

struct SubCategoryView: View {
    @Binding var tasks: [Task]
    let category: Category
    let subCategories: [SubCategory]

    private var filteredSubCategories: [SubCategory] {
        subCategories.filter { $0.parentCategoryID == category.id }
    }

    let gridLayout = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 16) {
                ForEach(filteredSubCategories) { subCategory in
                    NavigationLink(destination: Text("Task List for \(subCategory.name)")) {
                        SubcategoryCardView(subcategory: subCategory, category: category, taskCount: filteredTasksCount(for: subCategory))
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(category.name)
    }

    private func filteredTasksCount(for subCategory: SubCategory) -> Int {
        tasks.filter { $0.subCategoryID == subCategory.id }.count
    }
}

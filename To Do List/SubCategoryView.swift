import SwiftUI
import Foundation

struct SubCategoryView: View {
    @Binding var tasks: [Task]
    let category: Category
    @Binding var categoryData: CategoryManager.CategoryData
    var onEdit: (SubCategory) -> Void
    var onDelete: (SubCategory) -> Void

    private var filteredSubCategories: [SubCategory] {
        categoryData.subCategories.filter { $0.parentCategoryID == category.id }
    }

    let gridLayout = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridLayout, spacing: 16) {
                ForEach(filteredSubCategories) { subCategory in
                    NavigationLink(destination: TaskBoardView(tasks: $tasks, categoryData: $categoryData, selectedSubCategory: subCategory)) {
                        SubcategoryCardView(subcategory: subCategory, category: category, taskCount: filteredTasksCount(for: subCategory))
                            .contextMenu {
                                Button("Edit") { onEdit(subCategory) }
                                Button("Delete", role: .destructive) { onDelete(subCategory) }
                            }
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

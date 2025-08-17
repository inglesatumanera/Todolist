import SwiftUI
import Foundation

// Assuming a UserData struct for demonstration


struct HubView: View {
    @Binding var tasks: [Task]
    @Binding var userData: UserData?
    @Binding var categoryData: CategoryManager.CategoryData
    @State private var sheetContext: SheetContext?
    @State private var itemToDelete: Any?
    @State private var showingDeleteAlert = false

    enum SheetContext: Identifiable {
        case add
        case editCategory(Category)
        case editSubCategory(SubCategory)

        var id: String {
            switch self {
            case .add: return "add"
            case .editCategory(let category): return "edit-cat-\(category.id)"
            case .editSubCategory(let subCategory): return "edit-sub-\(subCategory.id)"
            }
        }
    }

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
                        NavigationLink(destination: SubCategoryView(
                            tasks: $tasks,
                            category: category,
                            categoryData: $categoryData,
                            onEdit: { subCategory in sheetContext = .editSubCategory(subCategory) },
                            onDelete: { subCategory in
                                itemToDelete = subCategory
                                showingDeleteAlert = true
                            }
                        )) {
                            HubCardView(category: category)
                                .contextMenu {
                                    Button("Edit") { sheetContext = .editCategory(category) }
                                    Button("Delete", role: .destructive) {
                                        itemToDelete = category
                                        showingDeleteAlert = true
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Goals Hub")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { sheetContext = .add }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onChange(of: tasks) { _ in
            PersistenceManager.saveTasks(tasks)
        }
        .sheet(item: $sheetContext) { context in
            switch context {
            case .add:
                EditCategoryView(categoryData: $categoryData)
            case .editCategory(let category):
                EditCategoryView(categoryData: $categoryData, categoryToEdit: category)
            case .editSubCategory(let subCategory):
                EditCategoryView(categoryData: $categoryData, subCategoryToEdit: subCategory)
            }
        }
        .alert("Are you sure?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let category = itemToDelete as? Category {
                    delete(category: category)
                } else if let subCategory = itemToDelete as? SubCategory {
                    delete(subCategory: subCategory)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private func delete(category: Category) {
        // Cascading delete
        categoryData.subCategories.removeAll { $0.parentCategoryID == category.id }
        categoryData.categories.removeAll { $0.id == category.id }
        CategoryManager.shared.save(categoryData)
    }

    private func delete(subCategory: SubCategory) {
        categoryData.subCategories.removeAll { $0.id == subCategory.id }
        CategoryManager.shared.save(categoryData)
    }
}

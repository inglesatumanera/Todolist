import SwiftUI

struct EditCategoryView: View {
    @Binding var categoryData: CategoryManager.CategoryData
    @Environment(\.dismiss) var dismiss

    // The item to edit, if any. This determines if we are in "Add" or "Edit" mode.
    var categoryToEdit: Category?
    var subCategoryToEdit: SubCategory?

    private enum CreationType: String, CaseIterable, Identifiable {
        case category = "Main Category"
        case subCategory = "Sub-Category"
        var id: Self { self }
    }

    @State private var creationType: CreationType = .category
    @State private var name = ""
    @State private var selectedParentID: UUID?
    @State private var selectedColorName = "blue"
    @State private var selectedIconName = "briefcase"

    // Predefined options for the user
    private let colorOptions: [String: Color] = [
        "blue": .blue, "green": .green, "orange": .orange, "gray": .gray,
        "purple": .purple, "teal": .teal, "red": .red, "pink": .pink
    ]
    private let iconOptions = [
        "briefcase", "heart", "person", "house", "lightbulb", "dollarsign",
        "book", "car", "flag", "star", "gear", "flame"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Type", selection: $creationType) {
                        ForEach(CreationType.allCases) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: creationType) { _ in
                        // Set a default parent if switching to sub-category and one doesn't exist
                        if creationType == .subCategory && selectedParentID == nil {
                            selectedParentID = categoryData.categories.first?.id
                        }
                    }
                }

                Section(header: Text("Details")) {
                    TextField("Name", text: $name)

                    if creationType == .category {
                        Picker("Color", selection: $selectedColorName) {
                            ForEach(colorOptions.keys.sorted(), id: \.self) { colorName in
                                HStack {
                                    Circle().fill(colorOptions[colorName]!).frame(width: 20, height: 20)
                                    Text(colorName.capitalized)
                                }.tag(colorName)
                            }
                        }

                        Picker("Icon", selection: $selectedIconName) {
                            ForEach(iconOptions, id: \.self) { iconName in
                                Image(systemName: iconName).tag(iconName)
                            }
                        }
                        .pickerStyle(.navigationLink)

                    } else {
                        Picker("Parent Category", selection: $selectedParentID) {
                            Text("None").tag(nil as UUID?)
                            ForEach(categoryData.categories) { category in
                                Text(category.name).tag(category.id as UUID?)
                            }
                        }
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: setupForEdit)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(name.isEmpty || (creationType == .subCategory && selectedParentID == nil))
                }
            }
        }
    }

    private func save() {
        switch creationType {
        case .category:
            if let id = categoryToEdit?.id, let index = categoryData.categories.firstIndex(where: { $0.id == id }) {
                // Edit existing category
                categoryData.categories[index].name = name
                categoryData.categories[index].colorName = selectedColorName
                categoryData.categories[index].iconName = selectedIconName
            } else {
                // Add new category
                let newCategory = Category(id: UUID(), name: name, colorName: selectedColorName, iconName: selectedIconName)
                categoryData.categories.append(newCategory)
            }
        case .subCategory:
            guard let parentID = selectedParentID else { return }
            if let id = subCategoryToEdit?.id, let index = categoryData.subCategories.firstIndex(where: { $0.id == id }) {
                // Edit existing sub-category
                categoryData.subCategories[index].name = name
                categoryData.subCategories[index].parentCategoryID = parentID
            } else {
                // Add new sub-category
                let newSubCategory = SubCategory(id: UUID(), name: name, parentCategoryID: parentID)
                categoryData.subCategories.append(newSubCategory)
            }
        }
        CategoryManager.shared.save(categoryData)
    }

    private var navigationTitle: String {
        if categoryToEdit != nil || subCategoryToEdit != nil {
            return "Edit \(creationType.rawValue)"
        } else {
            return "New \(creationType.rawValue)"
        }
    }

    private func setupForEdit() {
        if let category = categoryToEdit {
            creationType = .category
            name = category.name
            selectedColorName = category.colorName
            selectedIconName = category.iconName
        } else if let subCategory = subCategoryToEdit {
            creationType = .subCategory
            name = subCategory.name
            selectedParentID = subCategory.parentCategoryID
        }
    }
}

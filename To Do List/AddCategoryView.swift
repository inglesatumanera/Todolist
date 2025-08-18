import SwiftUI

struct AddCategoryView: View {
    @Binding var categoryData: CategoryManager.CategoryData
    @Environment(\.dismiss) var dismiss

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
                    .onChange(of: creationType) {
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
            .navigationTitle(creationType == .category ? "New Category" : "New Sub-Category")
            .navigationBarTitleDisplayMode(.inline)
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
            let newCategory = Category(
                id: UUID(),
                name: name,
                colorName: selectedColorName,
                iconName: selectedIconName
            )
            categoryData.categories.append(newCategory)
        case .subCategory:
            guard let parentID = selectedParentID else { return }
            let newSubCategory = SubCategory(
                id: UUID(),
                name: name,
                parentCategoryID: parentID
            )
            categoryData.subCategories.append(newSubCategory)
        }
        CategoryManager.shared.save(categoryData)
    }
}

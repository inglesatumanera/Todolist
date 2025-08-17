import Foundation

class CategoryManager {
    static let shared = CategoryManager()
    private let fileURL: URL

    struct CategoryData: Codable, Equatable {
        var categories: [Category]
        var subCategories: [SubCategory]
    }

    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentsDirectory.appendingPathComponent("categoryData.json")
    }

    func load() -> CategoryData {
        guard let data = try? Data(contentsOf: fileURL) else {
            return createDefaultCategories()
        }

        do {
            let categoryData = try JSONDecoder().decode(CategoryData.self, from: data)
            // Check if loaded data is empty, if so, create defaults.
            // This handles the case of an empty file.
            if categoryData.categories.isEmpty {
                return createDefaultCategories()
            }
            return categoryData
        } catch {
            print("Error decoding CategoryData: \(error)")
            return createDefaultCategories()
        }
    }

    func save(_ data: CategoryData) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            try encodedData.write(to: fileURL, options: .atomic)
        } catch {
            print("Error encoding CategoryData: \(error)")
        }
    }

    private func createDefaultCategories() -> CategoryData {
        var defaultData = CategoryData(categories: [], subCategories: [])

        // 1. Work & Career
        let workId = UUID()
        defaultData.categories.append(Category(id: workId, name: "Work & Career", colorName: "blue", iconName: "briefcase"))
        defaultData.subCategories.append(contentsOf: [
            SubCategory(id: UUID(), name: "Projects", parentCategoryID: workId),
            SubCategory(id: UUID(), name: "Day Job", parentCategoryID: workId),
            SubCategory(id: UUID(), name: "My Business", parentCategoryID: workId)
        ])

        // 2. Health & Wellness
        let healthId = UUID()
        defaultData.categories.append(Category(id: healthId, name: "Health & Wellness", colorName: "green", iconName: "heart"))
        defaultData.subCategories.append(contentsOf: [
            SubCategory(id: UUID(), name: "Fitness", parentCategoryID: healthId),
            SubCategory(id: UUID(), name: "Nutrition", parentCategoryID: healthId),
            SubCategory(id: UUID(), name: "Mental Health", parentCategoryID: healthId)
        ])

        // 3. Personal
        let personalId = UUID()
        defaultData.categories.append(Category(id: personalId, name: "Personal", colorName: "orange", iconName: "person"))
        defaultData.subCategories.append(contentsOf: [
            SubCategory(id: UUID(), name: "Errands", parentCategoryID: personalId),
            SubCategory(id: UUID(), name: "Hobbies", parentCategoryID: personalId),
            SubCategory(id: UUID(), name: "Social", parentCategoryID: personalId)
        ])

        // 4. Home & Family
        let homeId = UUID()
        defaultData.categories.append(Category(id: homeId, name: "Home & Family", colorName: "gray", iconName: "house"))
        defaultData.subCategories.append(contentsOf: [
            SubCategory(id: UUID(), name: "Chores", parentCategoryID: homeId),
            SubCategory(id: UUID(), name: "Finances", parentCategoryID: homeId),
            SubCategory(id: UUID(), name: "Kids", parentCategoryID: homeId)
        ])

        // 5. Learning & Growth
        let learningId = UUID()
        defaultData.categories.append(Category(id: learningId, name: "Learning & Growth", colorName: "purple", iconName: "lightbulb"))
        defaultData.subCategories.append(contentsOf: [
            SubCategory(id: UUID(), name: "Courses", parentCategoryID: learningId),
            SubCategory(id: UUID(), name: "Reading", parentCategoryID: learningId),
            SubCategory(id: UUID(), name: "Side Projects", parentCategoryID: learningId)
        ])

        // 6. Finance
        let financeId = UUID()
        defaultData.categories.append(Category(id: financeId, name: "Finance", colorName: "teal", iconName: "dollarsign"))
        defaultData.subCategories.append(contentsOf: [
            SubCategory(id: UUID(), name: "Bills", parentCategoryID: financeId),
            SubCategory(id: UUID(), name: "Investments", parentCategoryID: financeId),
            SubCategory(id: UUID(), name: "Budgeting", parentCategoryID: financeId)
        ])

        save(defaultData)
        return defaultData
    }
}

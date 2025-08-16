import SwiftUI

struct SubcategoryCardView: View {
    let subcategory: SubCategory
    let category: Category // Pass the parent category to get color/icon
    let taskCount: Int

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: category.iconName)
                .font(.largeTitle)
                .foregroundColor(category.color)
            
            Text(subcategory.name)
                .font(.headline)
                .foregroundColor(.primary)

            Text("\(taskCount) tasks")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

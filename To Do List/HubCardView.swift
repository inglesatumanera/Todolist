import SwiftUI

struct HubCardView: View {
    let category: Category

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: category.iconName)
                .font(.largeTitle)
                .foregroundColor(category.color)
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

import SwiftUI

struct HubCardView: View {
    let parentCategory: ParentCategory

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImageName(for: parentCategory))
                .font(.largeTitle)
                .foregroundColor(color(for: parentCategory))
            
            Text(parentCategory.rawValue)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
    
    private func systemImageName(for parent: ParentCategory) -> String {
        switch parent {
        case .business:
            return "briefcase.fill"
        case .personal:
            return "person.fill"
        case .home:
            return "house.fill"
        case .family: // New case
            return "heart.fill"
        }
    }
    
    private func color(for parent: ParentCategory) -> Color {
        switch parent {
        case .business:
            return .blue
        case .personal:
            return .green
        case .home:
            return .purple
        case .family: // New case
            return .red
        }
    }
}

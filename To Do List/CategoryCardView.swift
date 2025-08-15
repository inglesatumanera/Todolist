import SwiftUI

struct CategoryCardView: View {
    let categoryName: String
    let parentCategory: ParentCategory
    let taskCount: Int

    var body: some View {
        HStack {
            Image(systemName: systemImageName(for: parentCategory))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(color(for: parentCategory))
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text(categoryName)
                    .font(.headline)
                Text("\(taskCount) Tasks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
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

struct CategoryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCardView(categoryName: "Business", parentCategory: .business, taskCount: 5)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

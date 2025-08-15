import SwiftUI

struct SubcategoryCardView: View {
    let subcategory: TaskCategory
    let taskCount: Int

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImageName(for: subcategory))
                .font(.largeTitle)
                .foregroundColor(color(for: subcategory))
            
            Text(subcategory.rawValue)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }

    private func systemImageName(for subcategory: TaskCategory) -> String {
        switch subcategory {
        case .founderCeo:
            return "briefcase.fill"
        case .technology:
            return "gearshape.fill"
        case .youtubeChannel:
            return "play.rectangle.fill"
        case .tiktokContent:
            return "video.square.fill"
        case .facebookCommunity:
            return "person.2.fill"
        case .personal:
            return "person.fill"
        case .healthWellness:
            return "heart.fill"
        case .familyEvents:
            return "calendar.badge.heart.fill"
        case .sonActivities:
            return "figure.walk"
        }
    }

    private func color(for subcategory: TaskCategory) -> Color {
        switch subcategory {
        case .founderCeo:
            return .blue
        case .technology:
            return .gray
        case .youtubeChannel:
            return .red
        case .tiktokContent:
            return .black
        case .facebookCommunity:
            return .indigo
        case .personal:
            return .green
        case .healthWellness:
            return .pink
        case .familyEvents:
            return .red
        case .sonActivities:
            return .orange
        }
    }
}

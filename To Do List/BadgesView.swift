import SwiftUI

struct BadgesView: View {
    let allBadges = BadgeProvider.allBadges
    let unlockedBadgeIDs = HealthDataManager.shared.unlockedBadges

    var body: some View {
        NavigationView {
            List(allBadges) { badge in
                HStack {
                    Image(systemName: badge.icon)
                        .font(.largeTitle)
                        .foregroundColor(unlockedBadgeIDs.contains(badge.id) ? .yellow : .gray)
                    VStack(alignment: .leading) {
                        Text(badge.name)
                            .font(.headline)
                        Text(badge.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Badges")
        }
    }
}

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Progress")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()

                    // Placeholder for charts
                    VStack {
                        Text("Weekly Water Intake")
                            .font(.headline)
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                    .padding()

                    // Placeholder for personal bests
                    VStack(alignment: .leading) {
                        Text("Personal Bests")
                            .font(.headline)
                        Text("Longest Streak: ... days")
                    }
                    .padding()

                    Spacer()
                }
            }
            .navigationTitle("Analytics")
        }
    }
}

import SwiftUI

struct GoalCardView: View {
    let goal: Goal
    let progress: Double

    var body: some View {
        VStack {
            // Display the custom photo if it exists, otherwise show a placeholder
            if let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.secondary)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
            }

            Spacer()

            Text(goal.title)
                .font(.headline)
                .lineLimit(2)

            ProgressRingView(progress: progress, color: .blue, icon: "target")
                .frame(width: 50, height: 50)
                .padding(.top, 5)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

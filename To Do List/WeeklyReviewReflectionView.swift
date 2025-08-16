import SwiftUI

struct WeeklyReviewReflectionView: View {
    let date: Date
    @State private var weeklyReview = WeeklyReview()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Weekly Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            Text("What went well last week?")
                .font(.title2)
                .fontWeight(.semibold)
            TextEditorWithPlaceholder(text: $weeklyReview.whatWentWell, placeholder: "List your wins, big or small...")
                .frame(height: 150)


            Text("What's one thing to improve for next week?")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            TextEditorWithPlaceholder(text: $weeklyReview.whatToImprove, placeholder: "What's a small change you can make?")
                .frame(height: 150)

            Spacer()
        }
        .padding()
        .onAppear {
            self.weeklyReview = WeeklyReviewManager.shared.load(for: date)
        }
        .onChange(of: weeklyReview) { newValue in
            WeeklyReviewManager.shared.save(newValue, for: date)
        }
    }
}

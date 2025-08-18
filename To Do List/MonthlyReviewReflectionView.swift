import SwiftUI

struct MonthlyReviewReflectionView: View {
    let date: Date
    @State private var monthlyReview = MonthlyReview()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Monthly Reflection")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            Text("What was your biggest win this month?")
                .font(.title2)
                .fontWeight(.semibold)
            TextEditorWithPlaceholder(text: $monthlyReview.biggestWin, placeholder: "Describe your proudest moment...")
                .frame(height: 150)


            Text("What's one thing to improve next month?")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)
            TextEditorWithPlaceholder(text: $monthlyReview.whatToImprove, placeholder: "What's a small change you can make?")
                .frame(height: 150)

            Spacer()
        }
        .padding()
        .onAppear {
            self.monthlyReview = MonthlyReviewManager.shared.load(for: date)
        }
        .onChange(of: monthlyReview) { _, newValue in
            MonthlyReviewManager.shared.save(newValue, for: date)
        }
    }
}

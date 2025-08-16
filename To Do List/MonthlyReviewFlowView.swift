import SwiftUI

struct MonthlyReviewFlowView: View {
    @Binding var tasks: [Task]
    let onFlowComplete: () -> Void

    private let date = Date()
    private var nextMonthDate: Date {
        Calendar.current.date(byAdding: .month, value: 1, to: date)!
    }

    var body: some View {
        TabView {
            MonthlyReviewSummaryView(tasks: tasks, date: date)
                .tag(0)

            ScrollView {
                VStack {
                    MonthlyReviewReflectionView(date: date)

                    Divider().padding()

                    Text("Plan for Next Month")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom)

                    MonthlyThemeView(date: nextMonthDate)
                        .padding(.horizontal)

                    Spacer(minLength: 20)

                    Button("Finish Review & Plan") {
                        onFlowComplete()
                    }
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom)
                }
            }
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

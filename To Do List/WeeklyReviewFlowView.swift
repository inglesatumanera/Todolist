import SwiftUI

struct WeeklyReviewFlowView: View {
    @Binding var tasks: [Task]
    let onFlowComplete: () -> Void

    private let date = Date()

    var body: some View {
        TabView {
            WeeklyReviewAccomplishmentView(tasks: tasks, date: date)
                .tag(0)

            VStack {
                WeeklyReviewReflectionView(date: date)

                Button("Finish Review") {
                    onFlowComplete()
                }
                .padding()
                .frame(maxWidth: 300)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom)
            }
            .tag(1)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .bottom)
    }
}

import SwiftUI

struct ReturningUserFlowView: View {
    let tasks: [Task]
    let onFlowComplete: () -> Void

    @State private var currentStep = 0

    var body: some View {
        TabView(selection: $currentStep) {
            WelcomeView()
                .tag(0)

            YesterdayReviewView(tasks: tasks)
                .tag(1)

            TodayOverviewView(tasks: tasks, onBegin: onFlowComplete)
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .ignoresSafeArea()
    }
}

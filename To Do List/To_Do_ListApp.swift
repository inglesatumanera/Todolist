import SwiftUI

@main
struct To_Do_ListApp: App {
    @State private var showOnboarding = !PersistenceManager.isOnboardingComplete()

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView(isOnboardingComplete: $showOnboarding)
            } else {
                MainTabView()
            }
        }
    }
}

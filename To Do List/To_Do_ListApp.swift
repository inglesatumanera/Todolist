import SwiftUI

@main
struct To_Do_ListApp: App {
    @State private var showOnboarding = !PersistenceManager.isOnboardingComplete()
    @State private var showReturningUserFlow = To_Do_ListApp.shouldShowReturningUserFlow()

    // Lift the state of tasks to the App level
    @State private var tasks = PersistenceManager.loadTasks()

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingView(isOnboardingComplete: $showOnboarding)
            } else if showReturningUserFlow {
                ReturningUserFlowView(tasks: tasks, onFlowComplete: {
                    showReturningUserFlow = false
                    updateLastOpenDate()
                })
            } else {
                // Pass tasks down to MainTabView
                MainTabView(tasks: $tasks)
            }
        }
    }

    private static func shouldShowReturningUserFlow() -> Bool {
        // Only show the flow if onboarding is already complete.
        guard PersistenceManager.isOnboardingComplete() else {
            return false
        }

        let defaults = UserDefaults.standard
        guard let lastOpenDate = defaults.object(forKey: "lastOpenDate") as? Date else {
            return true
        }
        return !Calendar.current.isDateInToday(lastOpenDate)
    }

    private func updateLastOpenDate() {
        UserDefaults.standard.set(Date(), forKey: "lastOpenDate")
    }
}

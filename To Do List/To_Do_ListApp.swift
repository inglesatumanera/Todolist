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

    private static func getAppDay(for date: Date) -> Date {
        let calendar = Calendar.current
        // Subtract 5 hours to shift the day's start time
        let shiftedDate = calendar.date(byAdding: .hour, value: -5, to: date)!
        return calendar.startOfDay(for: shiftedDate)
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

        let lastAppDay = getAppDay(for: lastOpenDate)
        let currentAppDay = getAppDay(for: Date())

        return lastAppDay != currentAppDay
    }

    private func updateLastOpenDate() {
        UserDefaults.standard.set(Date(), forKey: "lastOpenDate")
    }
}

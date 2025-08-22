import SwiftUI
import UserNotifications

struct TimerSetupView: View {
    @Environment(\.dismiss) var dismiss
    let task: Task

    @State private var duration: Int = 25 // Default to 25 minutes

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set Timer Duration")) {
                    HStack {
                        TextField("Minutes", value: $duration, format: .number)
                            .keyboardType(.numberPad)
                        Text("minutes")
                    }
                }
            }
            .navigationTitle("Start Timer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        // The timer logic will be in the next step.
                        // For now, just schedule a dummy notification.
                        let content = UNMutableNotificationContent()
                        content.title = "Time's up for \(task.title)!"
                        content.sound = .default

                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(duration * 60), repeats: false)
                        let request = UNNotificationRequest(identifier: "timer-\(task.id.uuidString)", content: content, trigger: trigger)

                        UNUserNotificationCenter.current().add(request)

                        dismiss()
                    }
                }
            }
        }
    }
}

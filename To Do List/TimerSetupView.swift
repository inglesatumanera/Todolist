import SwiftUI
import UserNotifications

struct TimerSetupView: View {
    @Environment(\.dismiss) var dismiss
    let task: Task

    @State private var duration: Int = 25 // Default to 25 minutes
    @State private var selectedSound: String = "alarm_tone_1.caf"
    private let sounds = ["alarm_tone_1.caf", "classic_buzzer.wav"]

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

                Section(header: Text("Alarm Sound")) {
                    Picker("Sound", selection: $selectedSound) {
                        ForEach(sounds, id: \.self) { sound in
                            Text(sound).tag(sound)
                        }
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
                        NotificationManager.shared.scheduleTimerNotification(
                            task: task,
                            duration: TimeInterval(duration * 60),
                            sound: UNNotificationSoundName(rawValue: selectedSound)
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}

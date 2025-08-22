import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private let motivationalQuotes = [
        "Believe you can and you're halfway there.",
        "The secret of getting ahead is getting started.",
        "The future belongs to those who believe in the beauty of their dreams."
    ]

    private let hourlyReminders = [
        "One hour at a time is all it takes. Keep pushing towards your goals!",
        "Time for a water break! Staying hydrated boosts energy and focus.",
        "Thinking about a snack? Fuel your body with something healthy."
    ]

    private init() {}

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            } else {
                print("Notification authorization granted: \(success)")
            }
        }
    }

    func scheduleTaskReminder(task: Task) {
        guard let dueDate = task.dueDate else { return }

        let content = UNMutableNotificationContent()
        content.title = "Upcoming Task"
        content.body = "'\(task.title)' starts in 10 minutes."
        content.sound = .default

        let triggerDate = dueDate.addingTimeInterval(-600) // 10 minutes before
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling task reminder: \(error.localizedDescription)")
            }
        }
    }

    func scheduleHourlyReminders() {
        let content = UNMutableNotificationContent()
        content.sound = .default

        for hour in 8...22 {
            content.title = "Hourly Check-in"
            content.body = hourlyReminders.randomElement() ?? "Time for a quick check-in!"

            var dateComponents = DateComponents()
            dateComponents.hour = hour

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "hourlyReminder-\(hour)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling hourly reminder for hour \(hour): \(error.localizedDescription)")
                }
            }
        }
    }

    func scheduleDailyMotivationalMoments() {
        let moments = [5, 13, 20] // 5 AM, 1 PM, 8 PM

        for hour in moments {
            let content = UNMutableNotificationContent()
            content.title = "A Moment of Motivation"
            content.body = motivationalQuotes.randomElement() ?? "You've got this!"
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = hour

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "motivationalMoment-\(hour)", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling motivational moment for hour \(hour): \(error.localizedDescription)")
                }
            }
        }
    }

    func scheduleRoutineReminder(routine: Routine) {
        guard let scheduledTime = routine.scheduledTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Time for your routine!"
        content.body = "It's time to start your '\(routine.name)' routine."
        content.sound = .default

        let triggerComponents = Calendar.current.dateComponents([.hour, .minute], from: scheduledTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

        let request = UNNotificationRequest(identifier: routine.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling routine reminder: \(error.localizedDescription)")
            }
        }
    }

    func scheduleTimerNotification(task: Task, duration: TimeInterval, sound: UNNotificationSoundName) {
        let content = UNMutableNotificationContent()
        content.title = "Time's up!"
        content.body = "Your timer for '\(task.title)' has finished."
        content.sound = UNNotificationSound(named: sound)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        let request = UNNotificationRequest(identifier: "timer-\(task.id.uuidString)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling timer notification: \(error.localizedDescription)")
            }
        }
    }
}

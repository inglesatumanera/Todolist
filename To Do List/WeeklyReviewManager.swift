import Foundation

class WeeklyReviewManager {
    static let shared = WeeklyReviewManager()
    private let defaults = UserDefaults.standard

    private func key(for date: Date) -> String {
        let calendar = Calendar.current
        // We are reviewing the *previous* week, so we get the key for the date from 7 days ago.
        guard let lastWeekDate = calendar.date(byAdding: .day, value: -7, to: date) else {
            // Fallback for safety, though this should not fail.
            let year = calendar.component(.yearForWeekOfYear, from: date)
            let week = calendar.component(.weekOfYear, from: date)
            return "weekly-review-\(year)-\(week)"
        }

        let year = calendar.component(.yearForWeekOfYear, from: lastWeekDate)
        let week = calendar.component(.weekOfYear, from: lastWeekDate)
        return "weekly-review-\(year)-\(week)"
    }

    func load(for date: Date) -> WeeklyReview {
        let currentKey = key(for: date)
        guard let data = defaults.data(forKey: currentKey) else {
            return WeeklyReview()
        }

        do {
            let review = try JSONDecoder().decode(WeeklyReview.self, from: data)
            return review
        } catch {
            print("Error decoding WeeklyReview: \(error)")
            return WeeklyReview()
        }
    }

    func save(_ review: WeeklyReview, for date: Date) {
        let currentKey = key(for: date)
        do {
            let data = try JSONEncoder().encode(review)
            defaults.set(data, forKey: currentKey)
        } catch {
            print("Error encoding WeeklyReview: \(error)")
        }
    }

    func markReviewAsSeen(for date: Date) {
        let seenKey = "seen-" + key(for: date)
        defaults.set(true, forKey: seenKey)
    }

    func hasSeenReviewPrompt(for date: Date) -> Bool {
        let seenKey = "seen-" + key(for: date)
        return defaults.bool(forKey: seenKey)
    }
}

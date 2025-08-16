import Foundation

class MonthlyReviewManager {
    static let shared = MonthlyReviewManager()
    private let defaults = UserDefaults.standard

    // The key is for the month being reviewed.
    private func key(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return "monthly-review-\(year)-\(month)"
    }

    func load(for date: Date) -> MonthlyReview {
        let currentKey = key(for: date)
        guard let data = defaults.data(forKey: currentKey) else {
            return MonthlyReview()
        }

        do {
            let review = try JSONDecoder().decode(MonthlyReview.self, from: data)
            return review
        } catch {
            print("Error decoding MonthlyReview: \(error)")
            return MonthlyReview()
        }
    }

    func save(_ review: MonthlyReview, for date: Date) {
        let currentKey = key(for: date)
        do {
            let data = try JSONEncoder().encode(review)
            defaults.set(data, forKey: currentKey)
        } catch {
            print("Error encoding MonthlyReview: \(error)")
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

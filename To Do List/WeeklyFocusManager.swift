import Foundation

class WeeklyFocusManager {
    static let shared = WeeklyFocusManager()
    private let defaults = UserDefaults.standard

    private func key(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.yearForWeekOfYear, from: date)
        let week = calendar.component(.weekOfYear, from: date)
        return "weekly-focus-\(year)-\(week)"
    }

    func load(for date: Date) -> WeeklyFocus {
        let currentKey = key(for: date)
        guard let data = defaults.data(forKey: currentKey) else {
            return WeeklyFocus()
        }

        do {
            let focus = try JSONDecoder().decode(WeeklyFocus.self, from: data)
            return focus
        } catch {
            print("Error decoding WeeklyFocus: \(error)")
            return WeeklyFocus()
        }
    }

    func save(_ focus: WeeklyFocus, for date: Date) {
        let currentKey = key(for: date)
        do {
            let data = try JSONEncoder().encode(focus)
            defaults.set(data, forKey: currentKey)
        } catch {
            print("Error encoding WeeklyFocus: \(error)")
        }
    }
}

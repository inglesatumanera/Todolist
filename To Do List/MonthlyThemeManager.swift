import Foundation

class MonthlyThemeManager {
    static let shared = MonthlyThemeManager()
    private let defaults = UserDefaults.standard

    private func key(for date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        return "monthly-theme-\(year)-\(month)"
    }

    func load(for date: Date) -> MonthlyTheme {
        let currentKey = key(for: date)
        guard let data = defaults.data(forKey: currentKey) else {
            return MonthlyTheme()
        }

        do {
            let theme = try JSONDecoder().decode(MonthlyTheme.self, from: data)
            return theme
        } catch {
            print("Error decoding MonthlyTheme: \(error)")
            return MonthlyTheme()
        }
    }

    func save(_ theme: MonthlyTheme, for date: Date) {
        let currentKey = key(for: date)
        do {
            let data = try JSONEncoder().encode(theme)
            defaults.set(data, forKey: currentKey)
        } catch {
            print("Error encoding MonthlyTheme: \(error)")
        }
    }
}

import SwiftUI

struct MonthlyThemeView: View {
    let date: Date
    @State private var monthlyTheme = MonthlyTheme()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Month's Theme")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)

            TextEditorWithPlaceholder(text: $monthlyTheme.theme, placeholder: "e.g., Focus on Fitness, Launch Website...")
                .frame(height: 60)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .onAppear {
            self.monthlyTheme = MonthlyThemeManager.shared.load(for: date)
        }
        .onChange(of: monthlyTheme) { _, newValue in
            MonthlyThemeManager.shared.save(newValue, for: date)
        }
    }
}

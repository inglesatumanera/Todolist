import SwiftUI

struct WeeklyFocusView: View {
    let date: Date
    @State private var weeklyFocus = WeeklyFocus()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week's Big Rocks")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)

            VStack(spacing: 8) {
                TextEditorWithPlaceholder(text: $weeklyFocus.goal1, placeholder: "What is your most important goal this week?")
                TextEditorWithPlaceholder(text: $weeklyFocus.goal2, placeholder: "What is your second most important goal?")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .onAppear {
            self.weeklyFocus = WeeklyFocusManager.shared.load(for: date)
        }
        .onChange(of: weeklyFocus) { newValue in
            WeeklyFocusManager.shared.save(newValue, for: date)
        }
    }
}

// Helper View for TextEditor with placeholder text
struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.secondary.opacity(0.7))
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
            TextEditor(text: $text)
                .frame(height: 60)
        }
        .padding(4)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

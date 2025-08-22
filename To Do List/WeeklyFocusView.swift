import SwiftUI

struct WeeklyFocusView: View {
    let date: Date
    @State private var weeklyFocus = WeeklyFocus()
    @FocusState private var focusedField: FocusableField?

    enum FocusableField: Hashable {
        case goal1
        case goal2
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("This Week's Big Rocks")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)

            VStack(spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if weeklyFocus.goal1.isEmpty {
                        Text("What is your most important goal this week?")
                            .foregroundColor(Color.secondary.opacity(0.7))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    TextEditor(text: $weeklyFocus.goal1)
                        .frame(height: 60)
                        .focused($focusedField, equals: .goal1)
                }
                .padding(4)
                .background(Color(.systemBackground))
                .cornerRadius(10)

                ZStack(alignment: .topLeading) {
                    if weeklyFocus.goal2.isEmpty {
                        Text("What is your second most important goal?")
                            .foregroundColor(Color.secondary.opacity(0.7))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    TextEditor(text: $weeklyFocus.goal2)
                        .frame(height: 60)
                        .focused($focusedField, equals: .goal2)
                }
                .padding(4)
                .background(Color(.systemBackground))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .onAppear {
            self.weeklyFocus = WeeklyFocusManager.shared.load(for: date)
        }
        .onChange(of: weeklyFocus) { _, newValue in
            WeeklyFocusManager.shared.save(newValue, for: date)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = nil
                }
            }
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

import SwiftUI

struct ContextLoggingView: View {
    let habit: Habit
    var onLog: (String, String) -> Void
    @Environment(\.dismiss) var dismiss

    @State private var feeling: String = ""
    @State private var location: String = ""

    let feelings = ["Stressed", "Tired", "Bored", "Social"]
    let locations = ["Home", "Work", "Restaurant"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("How were you feeling?")) {
                    Picker("Feeling", selection: $feeling) {
                        ForEach(feelings, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Where were you?")) {
                    Picker("Location", selection: $location) {
                        ForEach(locations, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Log Context")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Log") {
                        onLog(feeling, location)
                        dismiss()
                    }
                }
            }
        }
    }
}

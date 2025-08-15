import SwiftUI

struct RescheduleView: View {
    @Binding var task: Task
    @Environment(\.dismiss) var dismiss

    @State private var newDueDate: Date

    init(task: Binding<Task>) {
        self._task = task
        self._newDueDate = State(initialValue: task.wrappedValue.dueDate ?? Date())
    }

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select new due date",
                    selection: $newDueDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()

                Spacer()
            }
            .navigationTitle("Reschedule Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        task.dueDate = newDueDate
                        dismiss()
                    }
                }
            }
        }
    }
}

import SwiftUI

struct CreateRoutineView: View {
    @Environment(\.dismiss) var dismiss
    let routine: Routine?
    var onSave: (Routine) -> Void

    @State private var name: String = ""
    @State private var icon: String = "list.bullet"
    @State private var steps: [RoutineStep] = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Routine Details")) {
                    TextField("Routine Name", text: $name)
                    TextField("Icon Name (SF Symbol)", text: $icon)
                }

                Section(header: Text("Steps")) {
                    ForEach($steps) { $step in
                        VStack {
                            TextField("Step Name", text: $step.name)
                            TextField("Duration (seconds)", value: $step.durationInSeconds, format: .number)
                                .keyboardType(.numberPad)
                        }
                    }
                    .onDelete(perform: deleteStep)
                    .onMove(perform: moveStep)

                    Button(action: addStep) {
                        Label("Add Step", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(routine == nil ? "New Routine" : "Edit Routine")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRoutine()
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let routine = routine {
                    name = routine.name
                    icon = routine.icon
                    steps = routine.steps
                }
            }
        }
    }

    private func deleteStep(at offsets: IndexSet) {
        steps.remove(atOffsets: offsets)
    }

    private func moveStep(from source: IndexSet, to destination: Int) {
        steps.move(fromOffsets: source, toOffset: destination)
    }

    private func addStep() {
        steps.append(RoutineStep(id: UUID(), name: "", durationInSeconds: nil))
    }

    private func saveRoutine() {
        var routineToSave: Routine
        if let routine = routine {
            // Editing existing routine
            routineToSave = routine
            routineToSave.name = name
            routineToSave.icon = icon
            routineToSave.steps = steps
        } else {
            // Creating new routine
            routineToSave = Routine(id: UUID(), name: name, icon: icon, steps: steps)
        }
        onSave(routineToSave)
    }
}

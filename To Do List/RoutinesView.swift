import SwiftUI

struct RoutinesView: View {
    @State private var routines: [Routine] = []
    @State private var selectedRoutine: Routine?
    @State private var sheetDetail: SheetDetail?

    enum SheetDetail: Identifiable {
        case create
        case edit(Routine)

        var id: String {
            switch self {
            case .create:
                return "create"
            case .edit(let routine):
                return "edit-\(routine.id)"
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(routines) { routine in
                    Button(action: {
                        selectedRoutine = routine
                    }) {
                        HStack {
                            Image(systemName: routine.icon)
                                .font(.title)
                                .frame(width: 40)
                            Text(routine.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(.primary)
                    }
                    .contextMenu {
                        Button {
                            sheetDetail = .edit(routine)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .onDelete(perform: deleteRoutine)
            }
            .fullScreenCover(item: $selectedRoutine) { routine in
                GuidedRoutineView(routine: routine) {
                    updateStreak(for: routine)
                }
            }
            .navigationTitle("Routines")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { sheetDetail = .create }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $sheetDetail) { detail in
                switch detail {
                case .create:
                    CreateRoutineView(routine: nil) { newRoutine in
                        routines.append(newRoutine)
                        PersistenceManager.saveRoutines(routines)
                    }
                case .edit(let routine):
                    CreateRoutineView(routine: routine) { updatedRoutine in
                        if let index = routines.firstIndex(where: { $0.id == updatedRoutine.id }) {
                            routines[index] = updatedRoutine
                            PersistenceManager.saveRoutines(routines)
                        }
                    }
                }
            }
            .onAppear {
                routines = PersistenceManager.loadRoutines()
                if routines.isEmpty {
                    routines = createPreBuiltRoutines()
                    PersistenceManager.saveRoutines(routines)
                }
            }
        }
    }

    private func deleteRoutine(at offsets: IndexSet) {
        routines.remove(atOffsets:offsets)
        PersistenceManager.saveRoutines(routines)
    }

    private func updateStreak(for completedRoutine: Routine) {
        if let index = routines.firstIndex(where: { $0.id == completedRoutine.id }) {
            var routine = routines[index]

            if let lastCompletion = routine.lastCompletionDate,
               Calendar.current.isDateInYesterday(lastCompletion) {
                routine.streakCount += 1
            } else {
                routine.streakCount = 1
            }

            routine.lastCompletionDate = Date()

            routines[index] = routine
            PersistenceManager.saveRoutines(routines)
        }
    }

    private func createPreBuiltRoutines() -> [Routine] {
        let routine1 = Routine(
            id: UUID(),
            name: "5 AM Club Morning Routine",
            icon: "sun.haze.fill",
            steps: [
                RoutineStep(id: UUID(), name: "Wake up at 5 AM", durationInSeconds: nil),
                RoutineStep(id: UUID(), name: "20 minutes of exercise", durationInSeconds: 1200),
                RoutineStep(id: UUID(), name: "20 minutes of reflection/meditation", durationInSeconds: 1200),
                RoutineStep(id: UUID(), name: "20 minutes of learning", durationInSeconds: 1200)
            ]
        )

        let routine2 = Routine(
            id: UUID(),
            name: "Wind-Down Evening Routine",
            icon: "moon.stars.fill",
            steps: [
                RoutineStep(id: UUID(), name: "Turn off screens 1 hour before bed", durationInSeconds: nil),
                RoutineStep(id: UUID(), name: "Read a book for 30 minutes", durationInSeconds: 1800),
                RoutineStep(id: UUID(), name: "Journal for 10 minutes", durationInSeconds: 600),
                RoutineStep(id: UUID(), name: "Meditate for 5 minutes", durationInSeconds: 300)
            ]
        )

        let routine3 = Routine(
            id: UUID(),
            name: "Stress Relief Routine",
            icon: "leaf.fill",
            steps: [
                RoutineStep(id: UUID(), name: "Deep breathing exercises for 5 minutes", durationInSeconds: 300),
                RoutineStep(id: UUID(), name: "Go for a short walk", durationInSeconds: 900),
                RoutineStep(id: UUID(), name: "Listen to calming music", durationInSeconds: 600),
                RoutineStep(id: UUID(), name: "Stretch for 5 minutes", durationInSeconds: 300)
            ]
        )

        return [routine1, routine2, routine3]
    }
}

struct RoutinesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutinesView()
    }
}

import SwiftUI
import Combine

struct GuidedRoutineView: View {
    @Environment(\.dismiss) var dismiss
    let routine: Routine
    var onComplete: () -> Void

    @State private var currentStepIndex = 0
    @State private var timer: AnyCancellable?
    @State private var remainingTime: Int = 0
    @State private var showingExitAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if currentStepIndex < routine.steps.count {
                    let currentStep = routine.steps[currentStepIndex]

                    Text(currentStep.name)
                        .font(.largeTitle)
                        .padding()

                    if let duration = currentStep.durationInSeconds {
                        Text("\(formatTime(seconds: remainingTime))")
                            .font(.system(size: 80, weight: .bold, design: .monospaced))
                            .padding()
                    }

                    Button(action: completeStep) {
                        Text("Complete Step")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text("Routine Complete!")
                        .font(.largeTitle)
                        .padding()

                    Button(action: { dismiss() }) {
                        Text("Finish")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingExitAlert = true }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .alert("End Routine?", isPresented: $showingExitAlert) {
                Button("Cancel", role: .cancel) { }
                Button("End", role: .destructive) {
                    dismiss()
                }
            } message: {
                Text("Your progress for this session will not be saved.")
            }
            .onAppear(perform: setupStep)
            .onDisappear(perform: {
                timer?.cancel()
            })
        }
    }

    private func setupStep() {
        if currentStepIndex < routine.steps.count {
            let currentStep = routine.steps[currentStepIndex]
            if let duration = currentStep.durationInSeconds {
                remainingTime = duration
                startTimer()
            }
        }
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    completeStep()
                }
            }
    }

    private func completeStep() {
        timer?.cancel()
        currentStepIndex += 1
        if currentStepIndex < routine.steps.count {
            setupStep()
        } else {
            onComplete()
        }
    }

    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

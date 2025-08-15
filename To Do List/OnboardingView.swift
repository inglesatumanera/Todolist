import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @State private var name = ""
    @State private var goal1 = ""
    @State private var goal2 = ""
    @State private var goal3 = ""
    @State private var currentStep = 0

    var body: some View {
        VStack {
            if currentStep == 0 {
                nameStep
            } else {
                goalsStep
            }
        }
        .padding()
    }

    var nameStep: some View {
        VStack {
            Text("Welcome! What's your name?")
                .font(.largeTitle)
                .padding()
            TextField("Your Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Next") {
                if !name.isEmpty {
                    currentStep = 1
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }

    var goalsStep: some View {
        VStack {
            Text("What are your 3 biggest goals, \(name)?")
                .font(.largeTitle)
                .padding()
            TextField("Goal 1", text: $goal1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            TextField("Goal 2", text: $goal2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            TextField("Goal 3", text: $goal3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Done") {
                // Save the data
                saveOnboardingData()
                isOnboardingComplete = false
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
    }

    func saveOnboardingData() {
        let goals = [
            Goal(id: UUID(), title: goal1),
            Goal(id: UUID(), title: goal2),
            Goal(id: UUID(), title: goal3)
        ].filter { !$0.title.isEmpty }

        let userData = UserData(name: name, goals: goals)
        PersistenceManager.saveUserData(userData)
    }
}

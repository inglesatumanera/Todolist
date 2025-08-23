import SwiftUI

struct JourneyDetailView: View {
    let journey: Journey
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(journey.name)
                .font(.largeTitle)
                .padding()

            Text(journey.description)
                .padding()

            Button("Start Journey") {
                HealthDataManager.shared.startJourney(journey: journey)
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .navigationTitle(journey.name)
    }
}

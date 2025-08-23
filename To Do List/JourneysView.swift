import SwiftUI

struct JourneysView: View {
    let journeys = HealthDataManager.shared.journeys

    var body: some View {
        NavigationView {
            List {
                ForEach(journeys) { journey in
                    NavigationLink(destination: JourneyDetailView(journey: journey)) {
                        VStack(alignment: .leading) {
                            Text(journey.name)
                                .font(.headline)
                            Text(journey.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Journeys")
        }
    }
}

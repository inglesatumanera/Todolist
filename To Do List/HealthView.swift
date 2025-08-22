import SwiftUI

struct HealthView: View {
    var body: some View {
        VStack {
            Text("Health")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Coming Soon")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}

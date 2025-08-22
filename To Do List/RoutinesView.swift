import SwiftUI

struct RoutinesView: View {
    var body: some View {
        VStack {
            Text("Routines")
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

struct RoutinesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutinesView()
    }
}

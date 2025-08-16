import SwiftUI

struct AnimatedGradientView: View {
    let colors: [Color] = [
        Color(red: 0.1, green: 0.3, blue: 0.9), // Deep Blue
        Color(red: 0.3, green: 0.6, blue: 1.0), // Bright Blue
        Color(red: 0.0, green: 0.8, blue: 1.0), // Cyan
        Color(red: 0.4, green: 0.3, blue: 0.9)  // Indigo
    ]

    @State private var startPoint = UnitPoint(x: 0, y: 0)
    @State private var endPoint = UnitPoint(x: 1, y: 1)

    var body: some View {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                    self.startPoint = UnitPoint(x: 1, y: 1)
                    self.endPoint = UnitPoint(x: 0, y: 0)
                }
            }
    }
}

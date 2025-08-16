import SwiftUI

struct WelcomeView: View {
    @State private var quote = QuoteProvider.getRandomQuote()

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good morning"
        case 12..<18:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }

    var body: some View {
        ZStack {
            AnimatedGradientView()

            VStack(spacing: 20) {
                Text(greeting)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text(quote)
                    .font(.title2)
                    .italic()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

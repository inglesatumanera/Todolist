import SwiftUI

struct YesterdayReviewView: View {
    let tasks: [Task]

    var yesterdaysCompletedTasks: [Task] {
        tasks.filter { task in
            guard task.status == .completed, let completionDate = task.completionDate else {
                return false
            }
            return Calendar.current.isDateInYesterday(completionDate)
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("Yesterday's Wins")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                if yesterdaysCompletedTasks.isEmpty {
                    Text("You didn't complete any tasks yesterday. Let's make today count!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(yesterdaysCompletedTasks) { task in
                            Text(task.title)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
        }
    }
}

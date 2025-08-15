import SwiftUI

struct TodayOverviewView: View {
    let tasks: [Task]
    let onBegin: () -> Void

    var todaysTasks: [Task] {
        tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate)
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("Today's Plan")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                if todaysTasks.isEmpty {
                    Text("No tasks scheduled for today. A blank canvas!")
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("You have \(todaysTasks.count) task(s) today:")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    ScrollView {
                        ForEach(todaysTasks) { task in
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

                Button(action: onBegin) {
                    Text("Let's Begin!")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

import SwiftUI

struct SetGoalsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var dailyLog: DailyHealthLog

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Weight")) {
                    HStack {
                        Text("Current Weight")
                        Spacer()
                        TextField("Weight", value: $dailyLog.currentWeight, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("kg")
                    }
                }

                Section(header: Text("Daily Goals")) {
                    HStack {
                        Text("Calories")
                        Spacer()
                        TextField("Calories", value: $dailyLog.calorieGoal, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("kcal")
                    }
                    HStack {
                        Text("Protein")
                        Spacer()
                        TextField("Protein", value: $dailyLog.proteinGoal, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("g")
                    }
                    HStack {
                        Text("Carbs")
                        Spacer()
                        TextField("Carbs", value: $dailyLog.carbsGoal, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("g")
                    }
                    HStack {
                        Text("Fat")
                        Spacer()
                        TextField("Fat", value: $dailyLog.fatGoal, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                        Text("g")
                    }
                }
            }
            .navigationTitle("Set Goals")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

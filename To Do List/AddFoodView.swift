import SwiftUI

struct AddFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var category = "Protein"
    @State private var grams: Double = 0
    @State private var calories: Int = 0
    @State private var protein: Double = 0
    @State private var carbs: Double = 0
    @State private var fat: Double = 0

    let categories = ["Protein", "Carbs", "Fat"]
    var onAdd: (FoodItem) -> Void

    var body: some View {
        NavigationView {
            Form {
                TextField("Food Name", text: $name)

                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }

                HStack {
                    Text("Amount")
                    Spacer()
                    TextField("Grams", value: $grams, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    Text("g")
                }

                HStack {
                    Text("Calories")
                    Spacer()
                    TextField("Calories", value: $calories, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    Text("kcal")
                }

                HStack {
                    Text("Protein")
                    Spacer()
                    TextField("Grams", value: $protein, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    Text("g")
                }

                HStack {
                    Text("Carbs")
                    Spacer()
                    TextField("Grams", value: $carbs, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    Text("g")
                }

                HStack {
                    Text("Fat")
                    Spacer()
                    TextField("Grams", value: $fat, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                    Text("g")
                }
            }
            .navigationTitle("Add Food")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let newFood = FoodItem(name: name, category: category, grams: grams, calories: calories, protein: protein, carbs: carbs, fat: fat)
                    onAdd(newFood)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}

import SwiftUI

struct AddFoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var category = "Protein"
    @State private var grams: Double = 0
    @State private var calories: Int = 0

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
            }
            .navigationTitle("Add Food")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let newFood = FoodItem(name: name, category: category, grams: grams, calories: calories)
                    onAdd(newFood)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}

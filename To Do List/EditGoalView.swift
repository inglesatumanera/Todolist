import SwiftUI
import PhotosUI

struct EditGoalView: View {
    @Binding var goal: Goal
    let categoryData: CategoryManager.CategoryData
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Title")) {
                    TextField("Title", text: $goal.title)
                }

                Section(header: Text("Link to Category")) {
                    Picker("Category", selection: $goal.linkedCategoryID) {
                        Text("None").tag(UUID?.none)
                        ForEach(categoryData.categories) { category in
                            Text(category.name).tag(category.id as UUID?)
                        }
                    }
                }

                Section(header: Text("Goal Image")) {
                    // Display current image if it exists
                    if let imageData = goal.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(12)
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select Image", systemImage: "photo")
                    }
                }
            }
            .navigationTitle("Edit Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .task(id: selectedItem) {
                do {
                    guard let item = selectedItem else { return }
                    let data = try await item.loadTransferable(type: Data.self)
                    goal.imageData = data
                } catch {
                    print("Failed to load image: \(error)")
                }
            }
        }
    }
}

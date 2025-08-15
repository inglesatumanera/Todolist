import SwiftUI

@main
struct To_Do_ListApp: App {
    var body: some Scene {
        WindowGroup {
            HubView() // This is the fix. We start with the HubView.
        }
    }
}

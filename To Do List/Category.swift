import Foundation
import SwiftUI

struct Category: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var colorName: String
    var iconName: String

    var color: Color {
        switch colorName.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "gray": return .gray
        case "purple": return .purple
        case "teal": return .teal
        default: return .black
        }
    }
}

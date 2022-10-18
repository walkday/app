import SwiftUI

extension Color {
    static var random: Self {
        [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    }
}

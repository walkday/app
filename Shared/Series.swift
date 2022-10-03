import SwiftUI
import Walker

extension Series {
    var title: String {
        "\(self)".capitalized
    }
    
    var color: Color {
        switch self {
        case .calories:
            return .orange
        case .distance:
            return .mint
        case .steps:
            return .purple
        }
    }
    
    var symbol: String {
        switch self {
        case .calories:
            return "flame.fill"
        case .distance:
            return "app.connected.to.app.below.fill"
        case .steps:
            return "figure.run"
        }
    }
    
    func string(from value: Int, caption: Bool) -> AttributedString {
        switch self {
        case .calories:
            return .calories(value: value, caption: caption)
        case .distance:
            return .distance(value: value, caption: caption)
        case .steps:
            return .steps(value: value, caption: caption)
        }
    }
}

import SwiftUI

enum Series {
    case
    calories,
    distance,
    steps
}

extension Series {
    var title: String {
        "\(self)".capitalized
    }
    
    var color: Color {
        switch self {
        case .calories:
            return .orange
        case .distance:
            return .teal
        case .steps:
            return .indigo
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
}

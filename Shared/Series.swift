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
    
    var range: ClosedRange<CGFloat> {
        switch self {
        case .calories:
            return 100 ... 5000
        case .distance:
            return 1000 ... 20000
        case .steps:
            return 1000 ... 20000
        }
    }
    
    func string(from value: Int, caption: Bool) -> AttributedString {
        switch self {
        case .calories:
            return .calories(value: value)
        case .distance:
            return .distance(value: value)
        case .steps:
            return .steps(value: value, caption: caption)
        }
    }
}

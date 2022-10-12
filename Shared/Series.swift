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
            return 250 ... 2500
        case .distance:
            return 2000 ... 14000
        case .steps:
            return 2000 ... 16000
        }
    }
    
    func string(walk: Walk) -> AttributedString {
        string(value: walk[keyPath: keyPath])
    }
    
    func string(value: Int) -> AttributedString {
        switch self {
        case .calories:
            return .calories(value: value)
        case .distance:
            return .distance(value: value)
        case .steps:
            return .format(value: value, singular: "step", plural: "steps")
        }
    }
}

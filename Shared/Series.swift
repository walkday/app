import SwiftUI
import HealthKit
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
            return 600 ... 6000
        case .distance:
            return 5000 ... 30000
        case .steps:
            return 5000 ... 30000
        }
    }
    
    var step: CGFloat {
        switch self {
        case .calories:
            return 200
        case .distance:
            return 1000
        case .steps:
            return 1000
        }
    }
    
    var identifier: HKQuantityTypeIdentifier {
        switch self {
        case .calories:
            return .activeEnergyBurned
        case .distance:
            return .distanceWalkingRunning
        case .steps:
            return .stepCount
        }
    }
    
    var quantity: HKQuantityType {
        .init(identifier)
    }
    
    var unit: HKUnit {
        switch self {
        case .calories:
            return .largeCalorie()
        case .distance:
            return .meter()
        case .steps:
            return .count()
        }
    }
    
    func challenge(walk: Walk) -> AttributedString {
        challenge(value: walk[keyPath: keyPath])
    }
    
    func challenge(value: Int) -> AttributedString {
        switch self {
        case .calories, .distance:
            return string(value: value)
        case .steps:
            return .format(value: value, singular: "step", plural: "steps")
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
            return .plain(value: value)
        }
    }
}

public enum Series: UInt8, CaseIterable, Sendable {
    case
    calories,
    distance,
    steps
    
    public var keyPath: KeyPath<Walk, Int> {
        switch self {
        case .calories:
            return \.calories
        case .distance:
            return \.distance
        case .steps:
            return \.steps
        }
    }
    
    public var metric: WritableKeyPath<Settings.Metrics, Bool> {
        switch self {
        case .calories:
            return \.calories
        case .distance:
            return \.distance
        case .steps:
            return \.steps
        }
    }
}

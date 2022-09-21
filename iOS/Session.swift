import Foundation

final class Session: ObservableObject {
    let walks: [Walk]
    let challenge: Challenge
    
    init() {
        walks = (1 ... 300)
            .map {
                .init(date: Calendar.current.date(byAdding: .day, value: -($0), to: .now)!,
                      steps: .random(in: 3000 ..< 7000),
                      calories: .random(in: 500 ..< 3000),
                      distance: .random(in: 2000 ..< 5000))
            }
            .reversed()
        
        challenge = .init(value: 6000, series: .steps)
    }
}

import Foundation
import Combine
import Walker

extension Stats {
    final class Options: ObservableObject {
        @Published var calories = true
        @Published var distance = true
        @Published var steps = true
        @Published var goal = true
        @Published var selected: Walk?
        private var subs = Set<AnyCancellable>()
        
        init(session: Session) {
            session
                .cloud
                .map(\.preferences)
                .removeDuplicates()
                .sink { [weak self] preferences in
                    self?.calories = preferences.calories
                    self?.distance = preferences.distance
                    self?.steps = preferences.steps
                    self?.goal = preferences.goal
                }
                .store(in: &subs)
        }
        
        var selection: AttributedString {
            (Series.calories.string(from: selected!.calories, caption: true)
             + .init(", ") + Series.distance.string(from: selected!.distance, caption: true)
             + .init(", ") + Series.steps.string(from: selected!.steps, caption: true))
            .numeric(font: .callout, color: .secondary)
        }
    }
}

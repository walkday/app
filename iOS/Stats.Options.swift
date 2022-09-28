import Foundation
import Walker

extension Stats {
    final class Options: ObservableObject {
        @Published var preferences = Walker.Preferences()
        
        @Published var selected: Walk?
        
        init(session: Session) {
            session
                .cloud
                .map(\.preferences)
                .removeDuplicates()
                .assign(to: &$preferences)
        }
        
        var selection: AttributedString {
            (Series.calories.string(from: selected!.calories, caption: true)
             + .init(", ") + Series.distance.string(from: selected!.distance, caption: true)
             + .init(", ") + Series.steps.string(from: selected!.steps, caption: true))
            .numeric(font: .callout, color: .secondary)
        }
    }
}

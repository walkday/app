import SwiftUI

@main struct Bundle: WidgetBundle {
    static let provider = Provider()
    
    @WidgetBundleBuilder var body: some Widget {
        Small()
        Medium()
        Large()
        Circular()
        Steps()
        Calories()
        Distance()
    }
}

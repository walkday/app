import SwiftUI

@main struct Bundle: WidgetBundle {
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

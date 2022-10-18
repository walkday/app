import SwiftUI

@main struct Bundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        Activity()
        Steps()
        Calories()
        Distance()
        AccessoryProgress()
        AccessorySteps()
        AccessoryCalories()
        AccessoryDistance()
    }
}

import SwiftUI

@main struct Bundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        AccessoryProgress()
        AccessorySteps()
        AccessoryCalories()
        AccessoryDistance()
    }
}

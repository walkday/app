import ClockKit

final class Controller: NSObject, CLKComplicationDataSource {
    func complicationDescriptors() async -> [CLKComplicationDescriptor] {
        [.init(
            identifier: "walkday.watch",
            displayName: "Walk Day",
            supportedFamilies: CLKComplicationFamily.allCases)]
    }
    
    func currentTimelineEntry(for complication: CLKComplication) async -> CLKComplicationTimelineEntry? { nil }
}

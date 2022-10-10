import WidgetKit
import Walker

struct Provider: TimelineProvider {
    private let walk = Walk(steps: 4200, calories: 768, distance: 3200)
    
    func placeholder(in: Context) -> Entry {
        .init(walk: walk)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: walk))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
//        observatory.update(to: Defaults.coordinates)
        completion(.init(entries: [.init(walk: walk)],
                         policy: .after(Calendar.current.startOfDay(
                            for: Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now))))
    }
}

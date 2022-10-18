import WidgetKit
import Walker

final class Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .init(walk: nil, challenge: .init())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: nil, challenge: .init()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        DispatchQueue.main.async {
            Task {
                do {
                    var walk = try await Health.today
                    walk.steps = 1567
                    walk.calories = 345
                    walk.distance = 24456
                    completion(Self.entry(walk: walk, minutes: 20))
                } catch {
                    completion(Self.entry(error: error))
                }
            }
        }
    }
    
    private static var challenge: Challenge {
        if var data = UserDefaults(suiteName: "group.walkday.share")!.object(forKey: "challenge") as? Data,
           !data.isEmpty {
            return .init(data: &data)
        } else {
            return .init()
        }
    }
    
    #warning("test")
    private static func entry(error: Error) -> Timeline<Entry> {
        .init(entries: [.init(error: error)],
                         policy: .after(Calendar.current.date(byAdding: .minute, value: 40, to: .now)!))
    }
    
    private static func entry(walk: Walk?, minutes: Int) -> Timeline<Entry> {
        .init(entries: [.init(walk: walk, challenge: challenge)],
                         policy: .after(Calendar.current.date(byAdding: .minute, value: minutes, to: .now)!))
    }
}

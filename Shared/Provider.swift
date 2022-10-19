import WidgetKit
import Walker

final class Provider: TimelineProvider, Sendable {
    func placeholder(in: Context) -> Entry {
        .init(walk: walk, challenge: challenge ?? .init())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: walk, challenge: challenge ?? .init()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            do {
                walk = try await Health.today
            } catch { }
            completion(.init(entries: [.init(walk: walk, challenge: challenge ?? .init())],
                             policy: .after(Calendar.current.date(byAdding: .minute, value: 10, to: .now)!)))
        }
    }
    
    private var walk: Walk? {
        get {
            if var data = UserDefaults(suiteName: "group.walkday.share")!.object(forKey: "walk") as? Data,
               !data.isEmpty {
                return .init(data: &data)
            }
            return nil
        } set {
            guard let data = newValue?.data else { return }
            UserDefaults(suiteName: "group.walkday.share")!.set(data, forKey: "walk")
        }
    }
    
    private var challenge: Challenge? {
        if var data = UserDefaults(suiteName: "group.walkday.share")!.object(forKey: "challenge") as? Data,
           !data.isEmpty {
            return .init(data: &data)
        }
        return nil
    }
}

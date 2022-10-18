import WidgetKit
import Walker

final class Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry {
        .init(walk: walk, challenge: challenge ?? .init())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(.init(walk: walk, challenge: challenge ?? .init()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            do {
                completion(entry(walk: try await Health.today))
            } catch {
                completion(entry(walk: walk))
            }
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
    
    private func entry(walk: Walk?) -> Timeline<Entry> {
        .init(entries: [.init(walk: walk, challenge: challenge ?? .init())],
              policy: .after(Calendar.current.date(byAdding: .minute, value: 30, to: .now)!))
    }
}

import WidgetKit
import SwiftUI
import Walker
import CloudKit
import Combine
import Archivable

final class Provider: TimelineProvider, @unchecked Sendable {
    static let shared = Provider()
    static let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
#warning("test")
//    private var walks = [Walk(steps: 3000, calories: 2340, distance: 1500)] {
    private var walks = [Walk()]
//    private var walks = [Walk]() {
//        didSet {
//            guard oldValue != walks else { return }
////            refresh.send()
//        }
//    }
    
    private var challenge = Challenge()
    
    private var subs = Set<AnyCancellable>()
    private let refresh = PassthroughSubject<Void, Never>()
    private let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    private let health = Health(days: 1)
    
    init() {
        cloud
            .map(\.settings.challenge)
            .removeDuplicates()
            .sink { [weak self] in
                self?.challenge = $0
            }
            .store(in: &subs)
        
        Task {
            await health
                .begin { items, keyPath in
                    self.walks = [.init(steps: self.walks.last!.steps + 1)]
                    
//                    self.walks = self.walks.update(items: items, keyPath: keyPath, limit: 1)
//                    guard let self else { return }
                    
//                    DispatchQueue.global(qos: .background).async {
//                        self.walks = [.init(steps: self.walks.last!.steps + 1)]
//                        WidgetCenter.shared.reloadAllTimelines()
//                    }

//                    self.walks = self.walks.update(items: items, keyPath: keyPath, limit: 1)
//                    self.walks = walks
                }
        }
        
//        refresh
//            .debounce(for: .seconds(2), scheduler: DispatchQueue.global(qos: .utility))
//            .sink {
//                WidgetCenter.shared.reloadAllTimelines()
//            }
//            .store(in: &subs)
    }
    
    func placeholder(in: Context) -> Entry {
        entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        cloud.pull.send()
//        Task {
//            await retry(completion: completion)
//        }
        completion(.init(entries: [entry], policy: .atEnd))
    }
    
    private var entry: Entry {
        let last = walks.last ?? .init()
        return .init(walk: last, percent: challenge.percent(walk: last))
    }
    
    private func retry(completion: @escaping (Timeline<Entry>) -> Void) async {
        guard !walks.isEmpty else {
            do {
                try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
                await retry(completion: completion)
            } catch {
                
            }
            return
        }
        
        completion(.init(entries: [entry], policy: .atEnd))
    }
}

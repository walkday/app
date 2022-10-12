import WidgetKit
import SwiftUI
import Walker
import CloudKit
import Combine
import Archivable

final class Provider: TimelineProvider, @unchecked Sendable {
    static let shared = Provider()
    static let color = [Color.blue, .purple, .indigo, .pink, .orange, .teal, .mint, .cyan].randomElement()!
    
    private var walks = [Walk]() {
        didSet {
            guard oldValue != walks else { return }
            refresh.send()
        }
    }
    
    private var challenge = Challenge() {
        didSet {
            guard oldValue != challenge else { return }
            refresh.send()
        }
    }
    
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
        
        Task { [weak self] in
            await health
                .begin { [weak self] items, keyPath in
                    guard let self else { return }
                    let walks = self.walks.update(items: items, keyPath: keyPath, limit: 1)
                    self.walks = walks
                }
        }
        
        refresh
            .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink {
                WidgetCenter.shared.reloadAllTimelines()
            }
            .store(in: &subs)
    }
    
    func placeholder(in: Context) -> Entry {
        entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        cloud.pull.send()
        Task {
            await retry(completion: completion)
        }
    }
    
    private var entry: Entry {
        let last = walks.last ?? .init()
        return .init(walk: last, percent: challenge.percent(walk: last))
    }
    
    private func retry(completion: @escaping (Timeline<Entry>) -> Void) async {
        guard !walks.isEmpty else {
            do {
                try await Task.sleep(until: .now + .seconds(1), clock: .continuous)
                await retry(completion: completion)
            } catch {
                
            }
            return
        }
        
        completion(.init(entries: [entry], policy: .atEnd))    }
}

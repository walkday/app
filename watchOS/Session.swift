import SwiftUI
import CloudKit
import Combine
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var challenge = Challenge()
    @Published var settings = Settings()
    @Published private(set) var walks = [Walk]()
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    let color = Color.random
    private var health: Health?
    private var subs = Set<AnyCancellable>()
    
    init() {
        cloud
            .map(\.settings)
            .removeDuplicates()
            .assign(to: &$settings)
        
        cloud
            .map(\.settings.challenge)
            .removeDuplicates()
            .sink { [weak self] challenge in
                UserDefaults(suiteName: "group.walkday.share")!.setValue(challenge.data, forKey: "challenge")
                self?.challenge = challenge
            }
            .store(in: &subs)
        
#warning("testing")
walks = (0 ..< 14).map {
    .init(steps: .random(in: 3500 ... 7500),
          calories: .random(in: 1000 ... 2000),
          distance: .random(in: 2500 ... 4500),
          date: Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -$0, to: .now)!))
}.sorted()
    }
    
    var percent: Double {
        walks
            .last
            .map {
                challenge.percent(walk: $0)
            }
        ?? 0
    }
    
    @MainActor func connect() async {
        guard health == nil else { return }
        health = .init()
        
        try? await health!.auth()
        
        health!
            .begin { [weak self] items, keyPath in
                guard let self else { return }
                self.walks = self.walks.update(items: items, keyPath: keyPath)
            } failed: { [weak self] in
                self?.health = nil
            }
    }
}

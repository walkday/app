import SwiftUI
import Charts
import CloudKit
import Combine
import AVFoundation
import Walker
import Archivable

final class Session: ObservableObject, @unchecked Sendable {
    @Published var challenge = Challenge()
    @Published var settings = Settings()
    @Published private(set) var walks = [Walk]()
    let cloud = Cloud<Archive, CKContainer>.new(identifier: "iCloud.WalkDay")
    let store = Store()
    let color = Color.random
    private var health: Health?
    private var subs = Set<AnyCancellable>()
    private var audio: AVAudioPlayer?
    private var haptics: UINotificationFeedbackGenerator?
    
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
    }
    
    var percent: Double {
        walks
            .last
            .map {
                challenge.percent(walk: $0)
            }
        ?? 0
    }
    
    var ratio: Double {
        walks.isEmpty
        ? 0
        : .init(walks
            .map {
                challenge.percent(walk: $0)
            }
            .filter {
                $0 == 1
            }
            .count) / .init(walks.count)
    }
    
    var streak: Int {
        var result = 0
        let today = walks.last
        for walk in walks.reversed() {
            let completed = challenge.percent(walk: walk) == 1
            guard walk == today || completed else { break }
            
            if completed {
                result += 1
            }
        }
        return result
    }
    
    @MainActor func connect() async {
        guard health == nil else { return }
        health = .init()
        
        try? await health!.auth()
        
        await health!
            .begin { [weak self] items, keyPath in
                guard let self else { return }
                let walks = self.walks.update(items: items, keyPath: keyPath)
                
                if self.walks.isEmpty == true && !walks.isEmpty {
                    withAnimation(.easeInOut(duration: 0.3)) { [weak self] in
                        self?.walks = walks
                    }
                } else {
                    self.walks = walks
                }
            }
    }
    
    @MainActor func disconnect() async {
        health = nil
    }
    
    func activateSound() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    @MainActor func activeHaptics() {
        guard haptics == nil else { return }
        haptics = .init()
        haptics?.prepare()
    }
    
    func playSound() {
        guard
            let audio = try? AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Celebration", withExtension: "aiff")!)
        else { return }
        
        self.audio = audio
        audio.play()
    }
    
    @MainActor func vibrate() {
        activeHaptics()
        haptics?.notificationOccurred(.success)
    }
    
    func find(location: CGPoint, overlay: ChartProxy, proxy: GeometryProxy) -> Walk? {
        let x = location.x - proxy[overlay.plotAreaFrame].origin.x
        if let date = overlay.value(atX: x) as Date? {
            return walks
                .first {
                    Calendar.current.isDate($0.date, inSameDayAs: date)
                }
            ?? (date < walks.last!.date ? walks.first! : walks.last!)
        }
        return nil
    }
}

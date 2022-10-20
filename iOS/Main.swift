import SwiftUI
import WidgetKit

struct Main: View {
    @ObservedObject var session: Session
    @State private var stack = [Item.today]
    @State private var onboard = false
    @AppStorage("onboarding") private var onboarding = true
    @AppStorage("celebrate") private var celebrate = true
    @AppStorage("achievement") private var achievement = TimeInterval()
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some View {
        VStack(spacing: 0) {
            switch stack.last {
            case .celebration:
                Celebration(session: session) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        stack
                            .removeAll {
                                $0 == .celebration
                            }
                    }
                }
            case .purchased:
                Purchased(session: session) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        stack
                            .removeAll {
                                $0 == .purchased
                            }
                    }
                }
            default:
                Today(session: session)
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background {
            LinearGradient(stops: [.init(color: session.color.opacity(0.95), location: 0),
                                   .init(color: session.color.opacity(0.5), location: 0.4),
                                   .init(color: session.color.opacity(0.4), location: 0.5),
                                   .init(color: session.color.opacity(0.3), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
        .sheet(isPresented: $onboard) {
            Onboarding(session: session)
        }
        .task {
            delegate.session = session
            let session = session

            Task
                .detached {
                    await session.store.launch()
                }

            WidgetCenter.shared.reloadAllTimelines()
            
            if onboarding {
                onboard = true
            }
        }
        .onReceive(session.store.purchased) {
            if !stack.contains(.purchased) {
                withAnimation(.easeIn(duration: 0.3)) {
                    stack.append(.purchased)
                }
            }
        }
        .onChange(of: session.settings) { settings in
            Task {
                await session.cloud.update(settings: settings)
            }
        }
        .onChange(of: session.percent) {
            let last = Date(timeIntervalSince1970: achievement)
            guard
                onboarding == false,
                $0 == 1,
                let date = session.walks.last?.date,
                !stack.contains(.celebration),
                celebrate,
                last < .now,
                Calendar.current.isDate(date, inSameDayAs: .now),
                !Calendar.current.isDate(last, inSameDayAs: .now)
            else { return }
            withAnimation(.easeIn(duration: 0.5)) {
                stack.append(.celebration)
            }
        }
    }
}

private enum Item {
    case
    today,
    celebration,
    purchased
}

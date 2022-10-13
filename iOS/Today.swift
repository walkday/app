import SwiftUI

struct Today: View {
    @ObservedObject var session: Session
    @State private var metrics = false
    
    var body: some View {
        if let last = session.walks.last {
            Button {
                metrics = true
            } label: {
                ZStack {
                    background
                    Tracker(walk: last,
                            percent: session.percent,
                            metrics: session.settings.tracker)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 25)
                }
                .foregroundColor(.init(.systemBackground))
                .shadow(color: session.color.opacity(0.4), radius: 4)
                .padding(.horizontal)
                .frame(maxHeight: .greatestFiniteMagnitude)
            }
            .padding(.top, 10)
            .sheet(isPresented: $metrics) {
                Metrics(session: session)
            }
            
            Overview(session: session)
                .padding(.top, 50)
        } else {
            if session.health.available {
                Text("Loading health data...")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                Text("If this takes too long check that Walk Day is enabled to access Apple Health.")
                    .font(.footnote.weight(.regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: 260)
                    .padding(.top, 8)
            } else {
                Text("Apple Health not available")
                    .font(.body.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        
        Options(session: session)
            .padding(.top, 65)
            .padding(.bottom, 35)
    }
    
    @ViewBuilder private var background: some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(LinearGradient(colors: [session.color,
                                          session.color.opacity(0.6)],
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)
                .shadow(.inner(color: .white, radius: 1)))
    }
}

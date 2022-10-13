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
                    .padding(.bottom, 20)
                    .padding([.top, .leading, .trailing], 25)
                }
                .foregroundColor(.init(.systemBackground))
                .shadow(color: session.color.opacity(0.4), radius: 4)
                .padding(.horizontal)
                .frame(height: 400)
            }
            .padding(.top, 25)
            .sheet(isPresented: $metrics) {
                Metrics(session: session)
            }
            
            Overview(session: session)
                .padding(.top, 50)
                .padding(.bottom, 30)
        } else {
            Spacer()
            
            if session.health.available {
                Text("Loading health data...")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.white)
                Text("If this takes too long check that Walk Day is enabled to access Apple Health.")
                    .font(.footnote.weight(.regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: 260)
                    .padding(.top, 8)
            } else {
                Text("Apple Health not available")
                    .font(.callout.weight(.semibold))
                    .foregroundColor(.white)
            }
            Spacer()
        }
        
        Spacer()
        
        Options(session: session)
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

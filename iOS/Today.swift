import SwiftUI

struct Today: View {
    @ObservedObject var session: Session
    @State private var metrics = false
    @AppStorage("sponsor") private var sponsor = false
    
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
                    .padding(.bottom, 18)
                    .padding([.leading, .trailing, .top], 25)
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
                .padding(.top, 30)
            
            if sponsor {
                Spacer()
                    .frame(maxHeight: 180)
            }
        } else {
            Text("Loading health data...")
                .font(.body.weight(.semibold))
                .foregroundColor(.white)
                .padding(.top, 20)
            Text("If this takes too long check that Walk Day is enabled to access Apple Health.")
                .font(.footnote.weight(.regular))
                .foregroundColor(.white)
                .frame(maxWidth: 260)
                .padding(.top, 8)
            
            Spacer()
        }
        
        Options(session: session)
            .padding(.bottom, 25)
            .padding(.top, sponsor ? 0 : 30)
        
        if !sponsor {
            Froob(session: session)
                .padding(.bottom, 20)
        }
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

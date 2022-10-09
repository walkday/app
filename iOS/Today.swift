import SwiftUI

struct Today: View {
    @ObservedObject var session: Session
    @State private var metrics = false
    
    var body: some View {
        if let last = session.walks.last {
            Button {
                metrics = true
            } label: {
                Tracker(walk: last,
                        percent: session.percent,
                        color: session.color,
                        metrics: session.settings.tracker)
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
            
            if session.available {
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
}

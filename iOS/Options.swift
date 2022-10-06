import SwiftUI

struct Options: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(session.color.opacity(0.25))
                .frame(height: 42)
            
            HStack(spacing: 5) {
                Button {
                    session.preferences = true
                } label: {
                    Image(systemName: "slider.vertical.3")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .containerShape(Rectangle())
                }
                .sheet(isPresented: $preferences) {
                    Preferences(session: session)
                }
                
                Button {
                    session.goal = true
                } label: {
                    Image(systemName: "gauge.high")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .containerShape(Rectangle())
                }
                .sheet(isPresented: $goal) {
                    Goal(session: session)
                }
            }
            .symbolRenderingMode(.hierarchical)
            .padding(.horizontal, 6)
        }
        .fixedSize()
    }
}

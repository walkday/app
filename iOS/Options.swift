import SwiftUI

struct Options: View {
    let session: Session
    @State private var preferences = false
    @State private var goal = false
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.1))
                .frame(height: 38)
            
            HStack(spacing: 5) {
                Button {
                    
                } label: {
                    Image(systemName: "slider.vertical.3")
                        .font(.system(size: 18, weight: .medium))
                        .frame(width: 50, height: 50)
                        .containerShape(Rectangle())
                }
                .sheet(isPresented: $preferences, content: Preferences.init)
                
                Button {
                    goal = true
                } label: {
                    Image(systemName: "gauge.high")
                        .font(.system(size: 20, weight: .medium))
                        .frame(width: 50, height: 50)
                        .containerShape(Rectangle())
                }
                .sheet(isPresented: $goal) {
                    Goal(session: session)
                }
            }
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.primary)
            .padding(.horizontal, 6)
        }
        .fixedSize()
    }
}

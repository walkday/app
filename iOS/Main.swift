import SwiftUI

struct Main: View {
    @State private var preferences = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Button {
                    preferences = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue.shadow(.inner(color: .white, radius: 1)))
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 15, weight: .semibold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    .fixedSize()
                }
                .sheet(isPresented: $preferences, content: Preferences.init)
                
                Spacer()
                
                Text("\(Text("03:23").font(.title.weight(.semibold).monospacedDigit()).foregroundColor(.white)) left")
                    .font(.callout.weight(.semibold).monospacedDigit())
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.trailing, 5)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            Tracker(color: .blue)
            Overview(color: .blue)
                .padding(.vertical, 20)
            Spacer()
        }
        .background {
            LinearGradient(stops: [.init(color: .blue.opacity(0.95), location: 0),
                                   .init(color: .blue.opacity(0.3), location: 0.5),
                                   .init(color: .blue.opacity(0.25), location: 0.55),
                                   .init(color: .blue.opacity(0.1), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}

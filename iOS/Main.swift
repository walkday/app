import SwiftUI

struct Main: View {
    @State private var preferences = false
    
    var body: some View {
        VStack(spacing: 0) {
//            HStack(alignment: .bottom) {
//                Button {
//                    preferences = true
//                } label: {
//                    ZStack {
//                        Circle()
//                            .stroke(.white, style: .init(lineWidth: 1))
//                        Image(systemName: "slider.horizontal.3")
//                            .font(.system(size: 15, weight: .semibold))
//                            .symbolRenderingMode(.hierarchical)
//                            .foregroundColor(.white)
//                            .padding(10)
//                    }
//                    .fixedSize()
//                }
//                .sheet(isPresented: $preferences, content: Preferences.init)
//                
//                Spacer()
//                
//                Text("\(Text("03:23").font(.title.weight(.semibold).monospacedDigit()).foregroundColor(.white)) left")
//                    .font(.callout.weight(.semibold).monospacedDigit())
//                    .foregroundColor(.white.opacity(0.6))
//                    .padding(.trailing, 5)
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 15)
            Tracker(color: .blue)
                .padding(.top, 20)
            Overview(color: .blue)
            Spacer()
        }
        .background {
            LinearGradient(stops: [.init(color: .blue.opacity(0.95), location: 0),
                                   .init(color: .blue.opacity(0.3), location: 0.5),
                                   .init(color: .blue.opacity(0.2), location: 0.6),
                                   .init(color: .blue.opacity(0.0), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}

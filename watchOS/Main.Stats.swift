import SwiftUI
import Walker

extension Main {
    struct Stats: View {
        @ObservedObject var session: Session
        let walk: Walk
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                series(series: .calories)
                series(series: .distance)
                series(series: .steps)
            }
            .padding(.top, 10)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        
        @ViewBuilder private func series(series: Series) -> some View {
            if session.settings.watch[keyPath: series.metric] {
                ZStack {
                    Rectangle()
                        .fill(.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                    Text("\(Text(series.title).font(.callout.weight(.semibold))) \(Image(systemName: series.symbol))")
                        .font(.footnote)
                        .foregroundColor(session.color)
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                
                Text(series.string(walk: walk)
                    .numeric(font: .title2.weight(.semibold).monospacedDigit()))
                .font(.body.weight(.regular))
                .padding(.leading)
                .padding(.vertical, 4)
                
                Divider()
            }
        }
    }
}

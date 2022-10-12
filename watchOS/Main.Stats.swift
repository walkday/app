import SwiftUI
import Walker

extension Main {
    struct Stats: View {
        @ObservedObject var session: Session
        let walk: Walk
        
        var body: some View {
            VStack(alignment: .leading) {
                if session.settings.watch.calories {
                    Text("\(Text(Series.calories.title).font(.callout.weight(.medium))) \(Image(systemName: Series.calories.symbol))")
                        .font(.footnote)
                        .foregroundColor(session.color)
                    
                    Divider()
                    
                    Text(Series.calories.string(from: walk.calories)
                        .numeric(font: .title2.weight(.semibold).monospacedDigit()))
                    .font(.body.weight(.regular))
                    .padding(.bottom, 10)
                }
                
                if session.settings.watch.distance {
                    Text("\(Text(Series.distance.title).font(.callout.weight(.medium))) \(Image(systemName: Series.distance.symbol))")
                        .font(.footnote)
                        .foregroundColor(session.color)
                    
                    Divider()
                    
                    Text(Series.distance.string(from: walk.distance)
                        .numeric(font: .title2.weight(.semibold).monospacedDigit()))
                    .font(.body.weight(.regular))
                    .padding(.bottom, 10)
                }
                
                if session.settings.watch.steps {
                    Text("\(Text(Series.steps.title).font(.callout.weight(.medium))) \(Image(systemName: Series.steps.symbol))")
                        .font(.footnote)
                        .foregroundColor(session.color)
                    
                    Divider()
                    
                    Text(AttributedString.plain(value: walk.steps)
                        .numeric(font: .title2.weight(.semibold).monospacedDigit()))
                    .font(.body.weight(.regular))
                }
            }
            .padding()
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
    }
}

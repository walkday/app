import SwiftUI

struct Main: View {
    @ObservedObject var session: Session
    
    var body: some View {
        ScrollView {
            if session.walks.isEmpty {
                if session.health.available {
                    Text("Loading\nhealth data...")
                        .font(.callout.weight(.semibold))
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    Text("Walk Day needs to be allowed to access Apple Health.")
                        .font(.footnote.weight(.regular))
                        .padding([.leading, .trailing, .bottom])
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                } else {
                    Text("Apple Health not available")
                        .font(.callout.weight(.semibold))
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                
            } else {
                Tracker.Gauge(percent: session.percent)
                    .padding(.horizontal, 20)
                    .frame(height: 150)
                
                if let walk = session.walks.last, session.settings.tracker.content {
                    Stats(session: session, walk: walk)
                }
            }
        }
        .background {
            LinearGradient(stops: [.init(color: session.color, location: 0),
                                   .init(color: session.color.opacity(0.6), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}




/*
 import SwiftUI
 import Walker

 struct Tracker: View {
     let walk: Walk
     let percent: Double
     let color: Color
     let metrics: Settings.Metrics
     
     var body: some View {
         progress
             .padding(.horizontal)
         
         if metrics.content {
             grid
         }
     }
     
     private var progress: some View {
         ZStack {
             ZStack {
                 Progress(value: 1)
                     .stroke(.tertiary, style: .init(lineWidth: 8, lineCap: .round))
                 Progress(value: percent)
                     .stroke(.primary, style: .init(lineWidth: 8, lineCap: .round))
                     .animation(.easeInOut(duration: 0.6), value: percent)
             }
             .frame(height: 120)
             
             VStack(spacing: 3) {
                 Spacer()
                 Text(min(Int(percent * 100), 100).formatted())
                     .font(.system(size: percent >= 1 ? 36 : 40, weight: .semibold).monospacedDigit())
                 Text(verbatim: "%")
                     .font(.system(size: 18, weight: .heavy))
                     .padding(.bottom, 7)
             }
         }
     }
     
     private var grid: some View {
         VStack(alignment: .leading) {
             if metrics.calories {
                 Text("\(Image(systemName: Series.calories.symbol)) \(Text(Series.calories.title).font(.callout.weight(.medium)))")
                     .font(.footnote)
                     .padding(.top)
                     .foregroundColor(color)
                 
                 Divider()
                 
                 Text(Series.calories.string(from: walk.calories)
                     .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                              color: .primary))
                 .font(.body.weight(.regular))
                 .foregroundStyle(.secondary)
                 .padding(.bottom, 20)
             }
             
             if metrics.distance {
                 Text("\(Image(systemName: Series.distance.symbol)) \(Text(Series.distance.title).font(.callout.weight(.medium)))")
                     .font(.footnote)
                     .padding(.top)
                     .foregroundColor(color)
                 
                 Divider()
                 
                 Text(Series.distance.string(from: walk.distance)
                     .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                              color: .primary))
                 .font(.body.weight(.regular))
                 .foregroundStyle(.secondary)
                 .padding(.bottom, 20)
             }
             
             if metrics.steps {
                 Text("\(Image(systemName: Series.steps.symbol)) \(Text(Series.steps.title).font(.callout.weight(.medium)))")
                     .font(.footnote)
                     .padding(.top)
                     .foregroundColor(color)
                 
                 Divider()
                 
                 Text(AttributedString.plain(value: walk.steps)
                     .numeric(font: .title2.weight(.semibold).monospacedDigit(),
                              color: .primary))
                 .font(.body.weight(.regular))
                 .foregroundStyle(.secondary)
             }
         }
         .padding()
         .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
     }
 }

 */

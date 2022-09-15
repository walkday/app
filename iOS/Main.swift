import SwiftUI

struct Main: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.init(.systemBackground).opacity(0.5))
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 17, weight: .medium))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.blue)
                                .padding(10)
                        }
                        .fixedSize()
                    }
                    
                    Spacer()
                }
                .padding()
                
                VStack(spacing: 0) {
                    Text("78\(Text(verbatim: "%").font(.system(size: 20, weight: .regular)).baselineOffset(24).foregroundColor(.init(.systemBackground).opacity(0.6)))")
                        .font(.system(size: 60, weight: .semibold).monospacedDigit())
                        .padding(.top, 20)
                    Text("You are doing great!")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    ZStack(alignment: .leading) {
                        Capsule()
                            .foregroundStyle(.tertiary)
                        Capsule()
                            .frame(width: 200)
                    }
                    .frame(height: 3)
                    .padding(.vertical, 25)
                    .padding(.horizontal, 20)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Spacer()
                        Text("\(Text("\(Image(systemName: "flame")) Calories").font(.footnote).foregroundColor(.init(.systemBackground).opacity(0.6)))\n300")
                        Spacer()
                        Text("\(Text("\(Image(systemName: "ruler")) Distance").font(.footnote).foregroundColor(.init(.systemBackground).opacity(0.6)))\n1,9km")
                        Spacer()
                        Text("\(Text("\(Image(systemName: "figure.step.training")) Steps").font(.footnote).foregroundColor(.init(.systemBackground).opacity(0.6)))\n546")
                        Spacer()
                    }
                    .font(.body.weight(.semibold).monospacedDigit())
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                }
                .modifier(Card(fill: .blue))
            }
        }
        .background {
            LinearGradient(stops: [.init(color: .blue.opacity(0.6), location: 0),
                                   .init(color: .blue.opacity(0.3), location: 0.4),
                                   .init(color: .blue.opacity(0.2), location: 0.5),
                                   .init(color: .blue.opacity(0.15), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}

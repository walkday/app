import SwiftUI

struct Main: View {
    @State private var preferences = false
    @State private var stats = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                Button {
                    preferences = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(.systemBackground).opacity(0.5))
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 15, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.blue)
                            .padding(8)
                    }
                    .fixedSize()
                }
                .sheet(isPresented: $preferences) {
                    Text("Hello")
                        .presentationDetents([.fraction(0.7), .large])
                        .presentationDragIndicator(.hidden)
                }
                
                Spacer()
                
                Text("\(Text("03:23").font(.title.weight(.semibold).monospacedDigit()).foregroundColor(.init(.systemBackground))) left")
                    .font(.callout.weight(.semibold).monospacedDigit())
                    .foregroundColor(.init(.systemBackground).opacity(0.6))
                    .padding(.trailing, 5)
            }
            .padding(20)

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
                
                Grid(horizontalSpacing: 20) {
                    GridRow {
                        Text("\(Image(systemName: "flame")) Calories")
                        Text("\(Image(systemName: "ruler")) Distance")
                        Text("\(Image(systemName: "figure.step.training")) Steps")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    GridRow {
                        Text("300")
                        Text("1,9km")
                        Text("546")
                    }
                }
                .font(.body.weight(.semibold).monospacedDigit())
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            }
            .modifier(Card(fill: .blue))
            .fixedSize(horizontal: false, vertical: true)
            
            Button {
                stats = true
            } label: {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.clear)
            }
            .modifier(Card(fill: .blue.opacity(0.3)))
            .padding(.vertical, 20)
            .sheet(isPresented: $stats) {
                Text("Hello")
                    .presentationDetents([.fraction(0.5)])
            }
            
            Spacer()
        }
        .background {
            LinearGradient(stops: [.init(color: .blue.opacity(0.8), location: 0),
                                   .init(color: .blue.opacity(0.4), location: 0.35),
                                   .init(color: .blue.opacity(0.2), location: 0.45),
                                   .init(color: .blue.opacity(0.1), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
}

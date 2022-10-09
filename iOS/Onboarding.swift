import SwiftUI

struct Onboarding: View {
    let session: Session
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            heading
            
            Spacer()
            Spacer()
            
            challenge
            
            Spacer()
            
            metrics
            
            Spacer()
            Spacer()
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.title3.weight(.semibold))
                    .padding(.horizontal, 6)
            }
            .buttonBorderShape(.capsule)
            .buttonStyle(.bordered)
            .foregroundColor(session.color)
            .tint(.white)
            .padding(.bottom)
        }
        .padding()
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background {
            LinearGradient(stops: [.init(color: session.color, location: 0),
                                   .init(color: session.color.opacity(0.5), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
    }
    
    @ViewBuilder private var heading: some View {
        HStack {
            Text("Welcome\n\(Text("to").font(.title.weight(.medium)).foregroundColor(.white.opacity(0.7))) Walk Day")
                .font(.largeTitle.weight(.semibold))
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.top)
        HStack(alignment: .lastTextBaseline) {
            Text("Make this app your own\nin just a few steps.")
                .font(.title3.weight(.medium))
                .foregroundStyle(.secondary)
                .foregroundColor(.white)
                
            Spacer()
            
            Button("Dismiss") {
                dismiss()
            }
            .fontWeight(.semibold)
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .foregroundColor(.white)
        }
    }
    
    @ViewBuilder private var challenge: some View {
        HStack {
            Text("Daily Challenge")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
            Spacer()
        }
        Divider()
        HStack(alignment: .firstTextBaseline) {
            Text(session.settings.challenge.title
                .numeric(font: .title3.weight(.medium).monospacedDigit(), color: .white))
                .font(.body.weight(.regular))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Configure")
                    .font(.callout.weight(.medium))
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(session.color)
            .tint(.white)
        }
    }
    
    @ViewBuilder private var metrics: some View {
        HStack {
            Text("Metrics")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
            Spacer()
        }
        Divider()
        HStack(alignment: .firstTextBaseline) {
            Text("Show all")
                .font(.title3.weight(.regular))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Configure")
                    .font(.callout.weight(.medium))
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(session.color)
            .tint(.white)
        }
    }
}

import SwiftUI

struct Onboarding: View {
    let session: Session
    @State private var goal = false
    @State private var display = false
    @AppStorage("onboarding") private var onboarding = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                heading
                
                challenge
                
                metrics
                
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
            .padding(20)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .background {
            LinearGradient(stops: [.init(color: session.color, location: 0),
                                   .init(color: session.color.opacity(0.5), location: 1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
        }
        .task {
            onboarding = false
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
            
            Button("Skip") {
                dismiss()
            }
            .fontWeight(.semibold)
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .foregroundColor(.white)
        }
        .padding(.bottom, 60)
    }
    
    @ViewBuilder private var challenge: some View {
        Text("Daily Challenge")
            .font(.title2.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        Text("Your personal goal for walking every day")
            .font(.body.weight(.medium))
            .foregroundStyle(.secondary)
            .foregroundColor(.white)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        Divider()
        HStack(alignment: .firstTextBaseline) {
            Text(session.challenge.series.challenge(value: .init(session.challenge.value))
                .numeric(font: .title3.weight(.medium).monospacedDigit(), color: .white))
                .font(.body.weight(.regular))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Button {
                goal = true
            } label: {
                Text("Configure")
                    .font(.callout.weight(.medium))
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(session.color)
            .tint(.white)
            .sheet(isPresented: $goal) {
                Goal(session: session)
            }
        }
        .padding(.bottom, 50)
    }
    
    @ViewBuilder private var metrics: some View {
        Text("Metrics")
            .font(.title2.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        Text("What you want to keep track and display")
            .font(.body.weight(.medium))
            .foregroundStyle(.secondary)
            .foregroundColor(.white)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        Divider()
        HStack(alignment: .firstTextBaseline) {
            Text("Show all")
                .font(.title3.weight(.regular))
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                display = true
            } label: {
                Text("Configure")
                    .font(.callout.weight(.medium))
                    .padding(.horizontal, 4)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(session.color)
            .tint(.white)
            .sheet(isPresented: $display) {
                Today.Metrics(session: session)
            }
        }
        .padding(.bottom, 120)
    }
}

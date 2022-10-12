import SwiftUI

struct Celebration: View {
    let session: Session
    let dismiss: () -> Void
    @AppStorage("sounds") private var sounds = true
    @AppStorage("vibrations") private var vibrations = true
    @AppStorage("achievement") private var achievement = TimeInterval()
    @Environment(\.requestReview) private var review
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 90, weight: .ultraLight))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
            Text(session.challenge.title
                .numeric(font: .largeTitle.weight(.bold).monospacedDigit()))
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .foregroundColor(.white)
                .padding(.top, 30)
            ZStack {
                Rectangle()
                    .fill(.white)
                Text("CHALLENGE COMPLETE!")
                    .font(.body.weight(.bold))
                    .foregroundColor(session.color.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)
                    .padding(.vertical, 14)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 5)
            
            Spacer()
            
            Button {
                achievement = Date.now.timeIntervalSince1970
                review()
                dismiss()
            } label: {
                Text("Continue")
                    .font(.body.weight(.bold))
                    .padding(.horizontal)
                    .frame(minWidth: 140, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(session.color)
            .foregroundColor(.white)
            
            Spacer()
        }
        .background {
            Layer()
                .equatable()
        }
        .task {
            if sounds {
                session.playSound()
            }
            if vibrations {
                session.vibrate()
            }
        }
    }
}

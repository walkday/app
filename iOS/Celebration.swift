import SwiftUI

struct Celebration: View {
    let session: Session
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 90, weight: .ultraLight))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
            Text(session.settings.challenge.title
                .numeric(font: .largeTitle.weight(.bold).monospacedDigit(), color: .white))
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
            
            Button(action: dismiss) {
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
        }
    }
}

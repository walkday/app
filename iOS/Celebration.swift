import SwiftUI

struct Celebration: View {
    let session: Session
    let dismiss: () -> Void
    
    var body: some View {
        Spacer()
        
        Image(systemName: "trophy.fill")
            .font(.system(size: 80, weight: .ultraLight))
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.white)
        Text(session.settings.challenge.title
            .numeric(font: .largeTitle.weight(.bold).monospacedDigit(), color: .white))
            .font(.title2.weight(.medium))
            .multilineTextAlignment(.center)
            .frame(maxWidth: 320)
            .foregroundColor(.white)
            .padding(.top, 30)
        ZStack {
            Rectangle()
                .fill(.white)
            Text("Challenge Completed!")
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
}

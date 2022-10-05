import SwiftUI

struct About: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 180)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .background(Color("Background"), ignoresSafeAreaEdges: .all)
            Divider()
            VStack {
                Text("Walk Day")
                    .font(.title2.weight(.medium))
                    .foregroundColor(.primary)
                    .padding(.top, 20)
                Spacer()
                Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                    .font(.body.weight(.medium).monospacedDigit())
                    .foregroundStyle(.secondary)
                HStack(spacing: 0) {
                    Text("From Berlin with ")
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                    Image(systemName: "heart.fill")
                        .font(.footnote)
                        .foregroundStyle(.pink)
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

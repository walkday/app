import SwiftUI
import StoreKit

struct Sponsor: View {
    @ObservedObject var session: Session
    @State private var product: Product?
    @State private var alert = false
    @State private var error = ""
    @AppStorage("sponsor") private var sponsor = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: sponsor ? "heart.fill" : "heart")
                .font(.system(size: 50, weight: .semibold))
                .symbolRenderingMode(.multicolor)
            
            Spacer()
            
            Text("Sponsor Walk Day")
                .font(.title2.weight(.medium))
                .foregroundStyle(sponsor ? .tertiary : .primary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
            
            Text("Contributes to maintenance and\nmaking it available for everyone.")
                .font(.callout.weight(.regular))
                .multilineTextAlignment(.center)
                .foregroundStyle(sponsor ? .quaternary : .secondary)
                .frame(maxWidth: 300)
                .padding(.top, 2)
            
            if sponsor {
                Spacer()
                
                Text("Thank you")
                    .font(.body.weight(.medium))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                    .padding(.bottom, 2)
                
                Text("We received your contribution.")
                    .font(.footnote.weight(.regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: 320)
            } else {
                Button {
                    guard session.store.status.value == .ready else { return }
                    
                    if let product = product {
                        Task {
                            await session.store.purchase(product)
                        }
                    } else {
                        session.store.status.value = .error("Unable to connect to the App Store, try again later.")
                    }
                } label: {
                    Text("Sponsor")
                        .font(.body.weight(.bold))
                        .padding(.horizontal)
                        .frame(minWidth: 260, minHeight: 34)
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .padding(.vertical, 16)
                
                if let product = product {
                    Text("1 time purchase of " + product.displayPrice)
                        .multilineTextAlignment(.center)
                        .font(.footnote.weight(.regular))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: 280)
                }
            }
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.6), value: sponsor)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !sponsor {
                    Button("Restore Purchases") {
                        Task {
                            await session.store.restore()
                        }
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
        .alert(error, isPresented: $alert) { }
        .onReceive(session.store.status.receive(on: DispatchQueue.main)) {
            switch $0 {
            case let .error(fail):
                error = fail
                alert = true
            default:
                break
            }
        }
        .task {
            product = await session.store.load(item: .sponsor)
        }
    }
}

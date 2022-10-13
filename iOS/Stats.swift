import SwiftUI
import Walker

struct Stats: View {
    @ObservedObject var session: Session
    @State private var selected: Walk?
    @State private var configure = false
    @AppStorage("sponsor") private var sponsor = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                heading
                    .background(Color(.tertiarySystemBackground), ignoresSafeAreaEdges: .all)
                
                if session.settings.stats.content {
                    Display(session: session, selected: $selected)
                }
                
                Divider()
                
                metrics
                
                if !sponsor {
                    Froob(session: session)
                }
            }
        }
        .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder private var heading: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(selected == nil ? "Daily Achievements" : selected!.date.formatted(.dateTime.day().weekday(.wide)))
                .font(.title2.weight(.semibold))
                .padding(.leading)
                .offset(y: -4)
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.primary)
                    .frame(width: 56, height: 56)
                    .contentShape(Rectangle())
            }
        }
        
        Text(selection ?? "Past 14 days")
            .font(selected == nil ? .callout.weight(.regular) : .footnote.weight(.regular))
            .foregroundColor(.secondary)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .padding(.leading)
            .padding(.bottom, 8)
    }
    
    private var metrics: some View {
        HStack {
            Spacer()
            Button {
                configure = true
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 18, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(.secondary)
            .tint(.primary.opacity(0.05))
            .sheet(isPresented: $configure) {
                Metrics(session: session)
            }
        }
        .padding(.top, 5)
        .padding(.trailing)
    }
    
    private var selection: AttributedString? {
        selected
            .map { selected in
                session
                    .settings
                    .stats
                    .caption(walk: selected)
                    .numeric(font: .callout.monospacedDigit(), color: .primary)
            }
    }
    
    private func section(@ViewBuilder content: () -> some View) -> some View {
        VStack {
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground)))
        .padding(.horizontal)
    }
}

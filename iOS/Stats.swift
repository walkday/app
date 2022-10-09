import SwiftUI
import Walker

struct Stats: View {
    @ObservedObject var session: Session
    @State private var selected: Walk?
    @AppStorage("sponsor") private var sponsor = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heading
                    .background(Color(.tertiarySystemBackground), ignoresSafeAreaEdges: .all)
                
                if session.settings.iOSStats.content {
                    Display(session: session, selected: $selected)
                }
                
                Divider()
                
                filters
                rule
                
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
    
    private var filters: some View {
        section {
            Metric(value: $session.settings.iOSStats.calories, series: .calories)
            Divider()
            Metric(value: $session.settings.iOSStats.distance, series: .distance)
            Divider()
            Metric(value: $session.settings.iOSStats.steps, series: .steps)
        }
        .padding(.top)
    }
    
    private var rule: some View {
        section {
            Toggle(isOn: $session.settings.iOSStats.goal.animation(.easeInOut)) {
                HStack(spacing: 12) {
                    Text("Challenge")
                        .font(.callout.weight(.regular))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .tint(session.settings.challenge.series.color)
        }
        .padding(.vertical)
    }
    
    private var selection: AttributedString? {
        selected
            .map { selected in
                session
                    .settings
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

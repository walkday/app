import SwiftUI
import Walker

struct Stats: View {
    @ObservedObject var session: Session
    @State private var selected: Walk?
    @State private var configure = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            heading
                .background(Color(.tertiarySystemBackground), ignoresSafeAreaEdges: .all)
            
            if session.settings.stats.content {
                Display(session: session, selected: $selected)
            }
            
            metrics
            
            Divider()
            
            stats
            
            Spacer()
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
            .font(selected == nil ? .system(size: 20, weight: .regular) : .init(UIFont.systemFont(ofSize: 16, weight: .regular, width: .condensed)))
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
            .foregroundColor(.secondary)
            .padding(.top, 10)
            .sheet(isPresented: $configure) {
                Metrics(session: session)
            }
        }
        .padding(.trailing)
        .frame(height: 60)
    }
    
    private var stats: some View {
        section {
            HStack(alignment: .firstTextBaseline) {
                Text("Ratio")
                    .font(.body.weight(.medium))
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                Text(.format(value: Int(session.ratio * 100), singular: "%", plural: "%")
                    .numeric(font: .init(UIFont.systemFont(ofSize: 26, weight: .bold, width: .condensed)).monospacedDigit()))
                    .font(.callout.weight(.regular))
                    .foregroundColor(session.color)
            }
            
            Text("Average completed challenges.")
                .font(.footnote.weight(.regular))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            
            Divider()
            
            HStack {
                Text("Streak")
                    .font(.body.weight(.medium))
                Spacer()
                Text(.format(value: session.streak, singular: "day", plural: "days")
                    .numeric(font: .init(UIFont.systemFont(ofSize: 26, weight: .bold, width: .condensed)).monospacedDigit()))
                    .font(.callout.weight(.regular))
                    .foregroundColor(session.color)
            }
            
            Text("Continous challenges completed.")
                .font(.footnote.weight(.regular))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
        }
        .padding(.top)
    }
    
    private var selection: AttributedString? {
        selected
            .map { selected in
                session
                    .settings
                    .stats
                    .caption(walk: selected)
                    .numeric(font: .init(UIFont.systemFont(ofSize: 20, weight: .medium, width: .condensed)).monospacedDigit(), color: .primary)
            }
    }
    
    private func section(@ViewBuilder content: () -> some View) -> some View {
        VStack {
            content()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color(.systemBackground).opacity(0.6)))
        .padding(.horizontal)
    }
}

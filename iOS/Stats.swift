import SwiftUI

struct Stats: View {
    @ObservedObject var session: Session
    @StateObject private var options = Options()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heading
                    .background(Color(.tertiarySystemBackground), ignoresSafeAreaEdges: .all)
                
                Display(session: session, options: options)
                
                Divider()
                
                filters
                rule
            }
        }
        .background(Color(.secondarySystemBackground), ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder private var heading: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(options.selected == nil ? "Daily Achievements" : options.selected!.date.formatted(.dateTime.day().weekday(.wide)))
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
        
        Text(options.selected == nil ? "Past 14 days" : options.selection)
            .font(options.selected == nil ? .callout.weight(.regular) : .footnote.weight(.regular))
            .foregroundColor(options.selected == nil ? .secondary : .init(.tertiaryLabel))
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .padding(.leading)
            .padding(.bottom, 8)
    }
    
    private var filters: some View {
        section {
            toggle(.calories, value: $options.calories)
            Divider()
            toggle(.distance, value: $options.distance)
            Divider()
            toggle(.steps, value: $options.steps)
        }
        .padding(.top)
    }
    
    private var rule: some View {
        section {
            Toggle(isOn: $options.challenge.animation(.easeInOut)) {
                HStack(spacing: 12) {
                    Text("Challenge")
                        .font(.callout.weight(.regular))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: session.challenge.series.color))
        }
        .padding(.vertical)
    }
    
    private func toggle(_ series: Series, value: Binding<Bool>) -> some View {
        Toggle(isOn: value.animation(.easeInOut)) {
            HStack(spacing: 0) {
                Circle()
                    .fill(series.color)
                    .frame(width: 14, height: 14)
                
                Image(systemName: series.symbol)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.tertiary)
                    .frame(width: 30)
                    .padding(.leading, 5)
                
                Text(series.title)
                    .font(.callout.weight(.regular))
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: series.color))
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

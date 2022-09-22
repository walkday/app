import SwiftUI

struct Stats: View {
    @ObservedObject var session: Session
    @StateObject private var options = Options()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    heading
                    Display(session: session, options: options)
                }
                .background(Color(.systemBackground), ignoresSafeAreaEdges: .all)
                
                Divider()
                
                filters
                rule
                time
            }
        }
        .background(session.color.opacity(0.2).gradient, ignoresSafeAreaEdges: .all)
    }
    
    @ViewBuilder private var heading: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text("Daily Achievements")
                .font(.title2.weight(.semibold))
                .padding(.leading)
                .offset(y: -2)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24, weight: .regular))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.secondary)
                    .frame(width: 56, height: 56)
                    .contentShape(Rectangle())
            }
        }
        
        Text("Past 7 days")
            .font(.callout.weight(.regular))
            .foregroundColor(.secondary)
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
                    Text("Challenge rule")
                        .font(.callout.weight(.regular))
                        .foregroundStyle(.secondary)
                    Capsule()
                        .fill(session.challenge.series.color)
                        .frame(width: 30, height: 3)
                    Spacer()
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: session.challenge.series.color))
        }
        .padding(.vertical)
    }
    
    private var time: some View {
        section {
            Button {
                
            } label: {
                Text("Achievements Over Time")
                    .font(.callout.weight(.medium))
                    .frame(maxWidth: .greatestFiniteMagnitude, minHeight: 30)
                    .contentShape(Rectangle())
            }
        }
        .padding(.bottom)
    }
    
    private func toggle(_ series: Series, value: Binding<Bool>) -> some View {
        Toggle(isOn: value.animation(.easeInOut)) {
            HStack(spacing: 0) {
                Circle()
                    .fill(series.color)
                    .frame(width: 14, height: 14)
                
                Image(systemName: series.symbol)
                    .font(.system(size: 14, weight: .regular))
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

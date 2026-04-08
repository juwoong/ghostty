import SwiftUI

struct TabBarView: View {
    @ObservedObject var appState: AppState
    let onNewTab: () -> Void
    let onCloseTab: (UUID) -> Void

    private let barColor = Color(red: 0.10, green: 0.10, blue: 0.10)
    private let activeTabColor = Color(red: 0.16, green: 0.16, blue: 0.16)
    private let inactiveTabColor = Color(red: 0.12, green: 0.12, blue: 0.12)
    private let borderColor = Color.white.opacity(0.07)
    private let activeIndicatorColor = Color(red: 0.26, green: 0.65, blue: 0.98)
    private let textColor = Color.white.opacity(0.87)
    private let mutedTextColor = Color.white.opacity(0.62)
    private let secondaryMutedTextColor = Color.white.opacity(0.40)
    private let buttonFill = Color.white.opacity(0.035)

    private var sessions: [Session] {
        activeProject?.sessions ?? []
    }

    private var activeProject: Project? {
        appState.activeProject ?? appState.projects.first(where: { !$0.sessions.isEmpty })
    }

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(sessions) { session in
                        sessionTab(for: session)
                    }
                }
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            addSessionButton
                .padding(.horizontal, 10)
        }
        .background(barColor)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.white.opacity(0.03))
                .frame(height: 1)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(borderColor)
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private func sessionTab(for session: Session) -> some View {
        let isActive = session.id == appState.activeSessionId

        ZStack(alignment: .trailing) {
            Button {
                appState.selectSession(id: session.id)
            } label: {
                HStack(spacing: 9) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(tabDotColor(for: session.agentState))

                    Text(session.name)
                        .font(.system(size: 13, weight: isActive ? .semibold : .medium))
                        .foregroundStyle(isActive ? textColor : mutedTextColor)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.leading, 13)
                .padding(.trailing, 34)
                .frame(minWidth: 156, idealWidth: 188, maxWidth: 220, minHeight: 36)
                .background(isActive ? activeTabColor : inactiveTabColor)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(isActive ? activeIndicatorColor : .clear)
                        .frame(height: 2)
                }
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(borderColor)
                        .frame(width: 1)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(session.name) tab")
            .accessibilityValue(isActive ? "Selected" : "Not selected")

            Button {
                onCloseTab(session.id)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(isActive ? mutedTextColor : secondaryMutedTextColor)
                    .frame(width: 18, height: 18)
                    .background {
                        Circle()
                            .fill(Color.white.opacity(isActive ? 0.07 : 0.03))
                    }
            }
            .buttonStyle(.plain)
            .padding(.trailing, 9)
            .accessibilityLabel("Close \(session.name) tab")
        }
        .overlay(alignment: .leading) {
            if session.id == sessions.first?.id {
                Rectangle()
                    .fill(borderColor)
                    .frame(width: 1)
            }
        }
    }

    private var addSessionButton: some View {
        Button(action: onNewTab) {
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.72))
                .frame(width: 24, height: 24)
                .background {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(buttonFill)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("New tab")
    }

    private func tabDotColor(for state: AgentState) -> Color {
        switch state {
        case .idle:
            return Color.gray.opacity(0.8)
        case .thinking:
            return Color.blue.opacity(0.95)
        case .waitingInput:
            return Color.yellow.opacity(0.95)
        case .toolRunning:
            return Color.green.opacity(0.95)
        case .error:
            return Color.red.opacity(0.95)
        }
    }
}

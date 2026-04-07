import SwiftUI

struct TabBarView: View {
    @ObservedObject var appState: AppState

    private let barColor = Color(red: 0.12, green: 0.12, blue: 0.12)
    private let inactiveTabColor = Color.white.opacity(0.04)
    private let activeTabColor = Color.white.opacity(0.12)
    private let borderColor = Color.white.opacity(0.08)
    private let textColor = Color.white.opacity(0.88)
    private let mutedTextColor = Color.white.opacity(0.58)

    private var sessions: [Session] {
        activeProject?.sessions ?? []
    }

    private var activeProject: Project? {
        appState.activeProject ?? appState.projects.first(where: { !$0.sessions.isEmpty })
    }

    var body: some View {
        ZStack {
            barColor

            HStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(sessions) { session in
                            sessionTab(for: session)
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 6)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                addSessionButton
                    .padding(.trailing, 10)
            }
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

        Button {
            appState.selectSession(id: session.id)
        } label: {
            HStack(spacing: 7) {
                Circle()
                    .fill(tabDotColor(for: session.agentState))
                    .frame(width: 7, height: 7)

                Text(session.name)
                    .font(.system(size: 12, weight: isActive ? .semibold : .medium, design: .rounded))
                    .foregroundStyle(isActive ? textColor : mutedTextColor)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isActive ? activeTabColor : inactiveTabColor)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isActive ? Color.white.opacity(0.15) : Color.clear, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(session.name) tab")
        .accessibilityValue(isActive ? "Selected" : "Not selected")
    }

    private var addSessionButton: some View {
        Button {
            // Phase 1 placeholder.
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(textColor)
                .frame(width: 28, height: 24)
                .background {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(Color.white.opacity(0.05))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("New session")
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

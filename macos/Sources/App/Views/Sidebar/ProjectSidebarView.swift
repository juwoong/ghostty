import AppKit
import SwiftUI

struct ProjectSidebarView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 14) {
                    ForEach(appState.projects) { project in
                        ProjectSectionView(
                            project: project,
                            isActiveProject: project.id == appState.activeProject?.id,
                            activeSessionId: appState.activeSessionId,
                            onToggleExpansion: {
                                appState.toggleProjectExpansion(id: project.id)
                            },
                            onSelectSession: { session in
                                appState.selectSession(id: session.id)
                            }
                        )
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }

            footer
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var header: some View {
        HStack {
            Text("Projects")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.8)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    private var footer: some View {
        HStack {
            Button {
            } label: {
                Label("Add Project", systemImage: "plus")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.secondary)
            .accessibilityLabel("Add project placeholder")

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

private struct ProjectSectionView: View {
    let project: Project
    let isActiveProject: Bool
    let activeSessionId: UUID?
    let onToggleExpansion: () -> Void
    let onSelectSession: (Session) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: onToggleExpansion) {
                HStack(spacing: 8) {
                    Image(systemName: project.isExpanded ? "chevron.down" : "chevron.right")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 12, height: 12)

                    VStack(alignment: .leading, spacing: 1) {
                        Text(project.name)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(isActiveProject ? .primary : .primary)
                            .lineLimit(1)

                        Text(project.directoryPath)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(isActiveProject ? Color.primary.opacity(0.08) : Color.clear)
                )
            }
            .buttonStyle(.plain)

            if project.isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(project.sessions) { session in
                        SessionRowView(
                            session: session,
                            isActive: session.id == activeSessionId,
                            onSelect: { onSelectSession(session) }
                        )
                    }
                }
                .padding(.leading, 18)
            }
        }
    }
}

private struct SessionRowView: View {
    let session: Session
    let isActive: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                StateDot(state: session.agentState)

                Text(session.name)
                    .font(.subheadline)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(isActive ? Color.accentColor.opacity(0.18) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .stroke(isActive ? Color.accentColor.opacity(0.35) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .foregroundStyle(isActive ? .primary : .secondary)
    }
}

private struct StateDot: View {
    let state: AgentState

    var body: some View {
        Circle()
            .fill(color(for: state))
            .frame(width: 8, height: 8)
            .overlay(
                Circle()
                    .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
            )
            .accessibilityLabel(Text("\(stateLabel) state"))
    }

    private var stateLabel: String {
        switch state {
        case .idle: "Idle"
        case .thinking: "Thinking"
        case .waitingInput: "Waiting input"
        case .toolRunning: "Tool running"
        case .error: "Error"
        }
    }

    private func color(for state: AgentState) -> Color {
        switch state {
        case .idle:
            return Color.secondary.opacity(0.8)
        case .thinking:
            return Color.blue
        case .waitingInput:
            return Color.yellow
        case .toolRunning:
            return Color.green
        case .error:
            return Color.red
        }
    }
}

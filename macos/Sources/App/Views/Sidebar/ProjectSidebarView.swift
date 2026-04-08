import AppKit
import SwiftUI

struct ProjectSidebarView: View {
    @ObservedObject var appState: AppState

    private let sidebarBackground = Color(red: 0.11, green: 0.11, blue: 0.105)
    private let headerTextColor = Color.white.opacity(0.55)
    private let rowTextColor = Color.white.opacity(0.92)
    private let secondaryTextColor = Color.white.opacity(0.46)
    private let selectedRowFill = Color(red: 0.18, green: 0.27, blue: 0.42).opacity(0.72)
    private let selectedRowStroke = Color(red: 0.41, green: 0.55, blue: 0.74).opacity(0.45)
    private let rowBackground = Color.white.opacity(0.025)
    private let rowBorder = Color.white.opacity(0.045)
    private let separator = Color.white.opacity(0.06)

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(appState.projects) { project in
                        ProjectSectionView(
                            project: project,
                            isActiveProject: project.id == appState.activeProject?.id,
                            activeSessionId: appState.activeSessionId,
                            rowTextColor: rowTextColor,
                            secondaryTextColor: secondaryTextColor,
                            selectedRowFill: selectedRowFill,
                            selectedRowStroke: selectedRowStroke,
                            rowBackground: rowBackground,
                            rowBorder: rowBorder,
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
                .padding(.vertical, 10)
            }
        }
        .background(sidebarBackground)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Text("Projects")
                .font(.caption.weight(.semibold))
                .foregroundStyle(headerTextColor)
                .textCase(.uppercase)
                .tracking(1.0)

            Spacer(minLength: 0)

            Button(action: addProject, label: {
                Image(systemName: "plus")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(headerTextColor)
                    .frame(width: 18, height: 18)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.white.opacity(0.035))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(Color.white.opacity(0.05), lineWidth: 1)
                    )
            }
            )
            .buttonStyle(.plain)
            .accessibilityLabel("Register project")
        }
        .padding(.horizontal, 14)
        .padding(.top, 13)
        .padding(.bottom, 10)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(separator)
                .frame(height: 1)
        }
    }

    private func addProject() {
        let panel = NSOpenPanel()
        panel.title = "Register Project"
        panel.message = "Choose a project directory to show in the sidebar."
        panel.prompt = "Register"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.allowsMultipleSelection = false
        panel.directoryURL = URL(
            fileURLWithPath: appState.activeProject?.directoryPath ?? NSHomeDirectory()
        )

        guard panel.runModal() == .OK, let directoryURL = panel.url else { return }

        switch appState.registerProject(directoryPath: directoryURL.path) {
        case .added:
            return
        case .duplicate, .invalidPath:
            NSSound.beep()
        }
    }
}

private struct ProjectSectionView: View {
    let project: Project
    let isActiveProject: Bool
    let activeSessionId: UUID?
    let rowTextColor: Color
    let secondaryTextColor: Color
    let selectedRowFill: Color
    let selectedRowStroke: Color
    let rowBackground: Color
    let rowBorder: Color
    let onToggleExpansion: () -> Void
    let onSelectSession: (Session) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Button(action: onToggleExpansion) {
                HStack(spacing: 8) {
                    Image(systemName: project.isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(secondaryTextColor)
                        .frame(width: 11, height: 11)

                    Image(systemName: "folder.fill")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.white.opacity(0.55))

                    Text(project.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(rowTextColor)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isActiveProject ? Color.white.opacity(0.05) : rowBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(isActiveProject ? Color.white.opacity(0.075) : rowBorder, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            if project.isExpanded {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(project.sessions) { session in
                        SessionRowView(
                            session: session,
                            isActive: session.id == activeSessionId,
                            rowTextColor: rowTextColor,
                            secondaryTextColor: secondaryTextColor,
                            selectedRowFill: selectedRowFill,
                            selectedRowStroke: selectedRowStroke,
                            onSelect: { onSelectSession(session) }
                        )
                    }
                }
                .padding(.leading, 16)
            }
        }
    }
}

private struct SessionRowView: View {
    let session: Session
    let isActive: Bool
    let rowTextColor: Color
    let secondaryTextColor: Color
    let selectedRowFill: Color
    let selectedRowStroke: Color
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 7) {
                StateDot(state: session.agentState)

                Text(session.name)
                    .font(.subheadline.weight(isActive ? .semibold : .regular))
                    .foregroundStyle(isActive ? rowTextColor : secondaryTextColor)
                    .lineLimit(1)

                Spacer(minLength: 0)

                if isActive {
                    Text("CC")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.white.opacity(0.55))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.white.opacity(0.08))
                        )
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isActive ? selectedRowFill : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isActive ? selectedRowStroke : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(session.name) session")
        .accessibilityValue(isActive ? "Selected" : "Not selected")
    }
}

private struct StateDot: View {
    let state: AgentState

    var body: some View {
        Circle()
            .fill(color(for: state))
            .frame(width: 7, height: 7)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
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
            return Color.white.opacity(0.44)
        case .thinking:
            return Color(red: 0.44, green: 0.67, blue: 0.98)
        case .waitingInput:
            return Color(red: 0.94, green: 0.75, blue: 0.28)
        case .toolRunning:
            return Color(red: 0.35, green: 0.75, blue: 0.52)
        case .error:
            return Color(red: 0.89, green: 0.36, blue: 0.33)
        }
    }
}

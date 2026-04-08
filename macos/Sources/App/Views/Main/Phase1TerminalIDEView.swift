import AppKit
import SwiftUI

enum Phase1TerminalIDELayout {
    static let sidebarWidth: CGFloat = 226
    static let windowChromeHeight: CGFloat = 28
    static let tabBarHeight: CGFloat = 38
    static let rightPanelWidth: CGFloat = 212
    static let dividerWidth: CGFloat = 1

    static let rootBackground = Color(red: 0.13, green: 0.13, blue: 0.12)
    static let sidebarBackground = Color(red: 0.16, green: 0.16, blue: 0.15)
    static let panelBackground = Color(red: 0.15, green: 0.15, blue: 0.14)
    static let separator = Color.white.opacity(0.08)
}

private struct IDETopStrip: View {
    let background: Color

    var body: some View {
        background
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Phase1TerminalIDELayout.separator)
                    .frame(height: Phase1TerminalIDELayout.dividerWidth)
            }
            .frame(height: Phase1TerminalIDELayout.windowChromeHeight)
    }
}

private struct IDEDivider: View {
    var body: some View {
        Rectangle()
            .fill(Phase1TerminalIDELayout.separator)
            .frame(width: Phase1TerminalIDELayout.dividerWidth)
    }
}

private struct WorkspaceEmptyStateView: View {
    let onRegisterProject: () -> Void

    private let iconColor = Color(red: 0.72, green: 0.61, blue: 0.39)
    private let titleColor = Color.white.opacity(0.92)
    private let subtitleColor = Color.white.opacity(0.56)
    private let cardFill = Color.white.opacity(0.035)
    private let cardBorder = Color.white.opacity(0.08)

    var body: some View {
        VStack {
            VStack(spacing: 18) {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: 42, weight: .medium))
                    .foregroundStyle(iconColor)

                VStack(spacing: 8) {
                    Text("등록된 프로젝트가 없습니다")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(titleColor)

                    Text("프로젝트를 추가하면 사이드바와 탭이 연결되고, 현재 터미널 세션도 바로 붙습니다.")
                        .font(.subheadline)
                        .foregroundStyle(subtitleColor)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button("프로젝트 등록") {
                    onRegisterProject()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.36, green: 0.52, blue: 0.78))
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 30)
            .frame(maxWidth: 420)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(cardFill)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(cardBorder, lineWidth: 1)
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(32)
        .accessibilityElement(children: .contain)
    }
}

struct Phase1TerminalIDEView<TerminalContent: View>: View {
    @ObservedObject private var appState: AppState
    private let terminalContent: TerminalContent
    private let onRegisterProject: () -> Void
    private let onNewTab: () -> Void
    private let onCloseTab: (UUID) -> Void

    init(
        appState: AppState,
        onRegisterProject: @escaping () -> Void,
        onNewTab: @escaping () -> Void,
        onCloseTab: @escaping (UUID) -> Void,
        @ViewBuilder terminalContent: () -> TerminalContent
    ) {
        self._appState = ObservedObject(wrappedValue: appState)
        self.onRegisterProject = onRegisterProject
        self.onNewTab = onNewTab
        self.onCloseTab = onCloseTab
        self.terminalContent = terminalContent()
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                IDETopStrip(background: Phase1TerminalIDELayout.sidebarBackground)
                ProjectSidebarView(
                    appState: appState,
                    onRegisterProject: onRegisterProject
                )
            }
            .frame(width: Phase1TerminalIDELayout.sidebarWidth)
            .frame(maxHeight: .infinity)
            .background(Phase1TerminalIDELayout.sidebarBackground)

            IDEDivider()

            VStack(spacing: 0) {
                IDETopStrip(background: Phase1TerminalIDELayout.rootBackground)

                if appState.hasProjects {
                    TabBarView(
                        appState: appState,
                        onNewTab: onNewTab,
                        onCloseTab: onCloseTab
                    )
                        .frame(height: Phase1TerminalIDELayout.tabBarHeight)

                    terminalContent
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    WorkspaceEmptyStateView(onRegisterProject: onRegisterProject)
                }
            }
            .background(Phase1TerminalIDELayout.rootBackground)

            IDEDivider()

            VStack(spacing: 0) {
                IDETopStrip(background: Phase1TerminalIDELayout.panelBackground)
                RightPanelView()
            }
            .frame(width: Phase1TerminalIDELayout.rightPanelWidth)
            .frame(maxHeight: .infinity)
            .background(Phase1TerminalIDELayout.panelBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Phase1TerminalIDELayout.rootBackground)
        .ignoresSafeArea(.container, edges: .top)
    }
}

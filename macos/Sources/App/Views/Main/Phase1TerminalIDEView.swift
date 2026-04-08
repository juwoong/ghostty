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

struct Phase1TerminalIDEView<TerminalContent: View>: View {
    @ObservedObject private var appState: AppState
    private let terminalContent: TerminalContent
    private let onNewTab: () -> Void
    private let onCloseTab: (UUID) -> Void

    init(
        appState: AppState,
        onNewTab: @escaping () -> Void,
        onCloseTab: @escaping (UUID) -> Void,
        @ViewBuilder terminalContent: () -> TerminalContent
    ) {
        self._appState = ObservedObject(wrappedValue: appState)
        self.onNewTab = onNewTab
        self.onCloseTab = onCloseTab
        self.terminalContent = terminalContent()
    }

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                IDETopStrip(background: Phase1TerminalIDELayout.sidebarBackground)
                ProjectSidebarView(appState: appState)
            }
            .frame(width: Phase1TerminalIDELayout.sidebarWidth)
            .frame(maxHeight: .infinity)
            .background(Phase1TerminalIDELayout.sidebarBackground)

            IDEDivider()

            VStack(spacing: 0) {
                IDETopStrip(background: Phase1TerminalIDELayout.rootBackground)

                TabBarView(
                    appState: appState,
                    onNewTab: onNewTab,
                    onCloseTab: onCloseTab
                )
                    .frame(height: Phase1TerminalIDELayout.tabBarHeight)

                terminalContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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

import AppKit
import SwiftUI

enum Phase1TerminalIDELayout {
    static let sidebarWidth: CGFloat = 200
    static let rightPanelWidth: CGFloat = 180
    static let tabBarHeight: CGFloat = 32
    static let dividerWidth: CGFloat = 1
}

struct Phase1TerminalIDEView<TerminalContent: View>: View {
    @ObservedObject private var appState: AppState
    private let terminalContent: TerminalContent

    init(appState: AppState, @ViewBuilder terminalContent: () -> TerminalContent) {
        self._appState = ObservedObject(wrappedValue: appState)
        self.terminalContent = terminalContent()
    }

    var body: some View {
        HStack(spacing: 0) {
            ProjectSidebarView(appState: appState)
                .frame(width: Phase1TerminalIDELayout.sidebarWidth)
                .frame(maxHeight: .infinity)
                .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            VStack(spacing: 0) {
                TabBarView(appState: appState)
                    .frame(height: Phase1TerminalIDELayout.tabBarHeight)

                terminalContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            Divider()

            RightPanelView()
                .frame(width: Phase1TerminalIDELayout.rightPanelWidth)
                .frame(maxHeight: .infinity)
                .background(Color(nsColor: .underPageBackgroundColor))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

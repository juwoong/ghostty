import Foundation
import Testing
@testable import Ghostty

struct AppStateTests {
    @Test func registeredProjectsPersistAcrossAppStateReloads() {
        let suiteName = "AppStateTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let rootPath = normalizedPath("/tmp/ghostty-root")
        let projectPath = normalizedPath("/tmp/ghostty-feature")
        let state = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(state.projects.map(\.directoryPath) == [rootPath])
        #expect(state.registerProject(directoryPath: projectPath) == .added)

        let registeredProjectId = state.projects.last!.id
        state.toggleProjectExpansion(id: registeredProjectId)

        let restoredState = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(restoredState.projects.map(\.directoryPath) == [rootPath, projectPath])
        #expect(restoredState.projects.last?.isExpanded == false)
    }

    @Test func duplicateProjectsAreIgnored() {
        let suiteName = "AppStateTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let rootPath = normalizedPath("/tmp/ghostty-root")
        let state = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(state.registerProject(directoryPath: rootPath) == .duplicate)
        #expect(state.registerProject(directoryPath: "/tmp/ghostty-child") == .added)
        #expect(state.registerProject(directoryPath: "/tmp/ghostty-child") == .duplicate)
        #expect(state.projects.map(\.directoryPath) == [rootPath, normalizedPath("/tmp/ghostty-child")])
    }

    private func normalizedPath(_ path: String) -> String {
        URL(fileURLWithPath: path).standardizedFileURL.path
    }
}

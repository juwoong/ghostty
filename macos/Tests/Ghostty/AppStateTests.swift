import Foundation
import Testing
@testable import Ghostty

struct AppStateTests {
    @Test func appStateStartsEmptyWithoutStoredProjects() {
        let suiteName = "AppStateTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let rootPath = normalizedPath("/tmp/ghostty-root")
        let state = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(state.projects.isEmpty)
        #expect(state.hasProjects == false)
        #expect(state.activeSessionId == nil)
        #expect(state.projectPickerDirectoryPath == rootPath)
    }

    @Test func registeredProjectsPersistAcrossAppStateReloads() {
        let suiteName = "AppStateTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let rootPath = normalizedPath("/tmp/ghostty-root")
        let projectPath = normalizedPath("/tmp/ghostty-feature")
        let state = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(state.registerProject(directoryPath: projectPath) == .added)
        #expect(state.projects.map(\.directoryPath) == [projectPath])

        let registeredProjectId = state.projects[0].id
        state.toggleProjectExpansion(id: registeredProjectId)

        let restoredState = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(restoredState.projects.map(\.directoryPath) == [projectPath])
        #expect(restoredState.projects[0].isExpanded == false)
        #expect(restoredState.projectPickerDirectoryPath == projectPath)
    }

    @Test func duplicateProjectsAreIgnored() {
        let suiteName = "AppStateTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let rootPath = normalizedPath("/tmp/ghostty-root")
        let childPath = normalizedPath("/tmp/ghostty-child")
        let state = AppState(projectRootPath: rootPath, userDefaults: userDefaults)

        #expect(state.registerProject(directoryPath: childPath) == .added)
        #expect(state.registerProject(directoryPath: childPath) == .duplicate)
        #expect(state.projects.map(\.directoryPath) == [childPath])
    }

    private func normalizedPath(_ path: String) -> String {
        URL(fileURLWithPath: path).standardizedFileURL.path
    }
}

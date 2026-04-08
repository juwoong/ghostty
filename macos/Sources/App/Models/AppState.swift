import Foundation
import Combine

final class AppState: ObservableObject {
    enum ProjectRegistrationResult: Equatable {
        case added
        case duplicate
        case invalidPath
    }

    private struct StoredProject: Codable, Equatable {
        var directoryPath: String
        var isExpanded: Bool
    }

    private static let storedProjectsKey = "Phase1.RegisteredProjects"

    @Published var projects: [Project]
    @Published var activeSessionId: UUID?

    private let projectRootPath: String?
    private let userDefaults: UserDefaults?

    convenience init(
        projectRootPath: String = FileManager.default.currentDirectoryPath,
        userDefaults: UserDefaults = .ghostty
    ) {
        let normalizedRootPath = Self.normalizeDirectoryPath(projectRootPath)
        let projects = Self.initialProjects(
            projectRootPath: normalizedRootPath,
            userDefaults: userDefaults
        )

        self.init(
            projects: projects,
            projectRootPath: normalizedRootPath,
            userDefaults: userDefaults
        )
    }

    init(
        projects: [Project],
        activeSessionId: UUID? = nil,
        projectRootPath: String? = nil,
        userDefaults: UserDefaults? = nil
    ) {
        self.projects = projects
        self.projectRootPath = projectRootPath.map(Self.normalizeDirectoryPath)
        self.userDefaults = userDefaults
        self.activeSessionId = activeSessionId ?? projects
            .flatMap(\.sessions)
            .first(where: { $0.isActive })?
            .id ?? projects.first?.sessions.first?.id
        syncActiveSession()
    }

    var activeSession: Session? {
        projects
            .flatMap(\.sessions)
            .first(where: { $0.id == activeSessionId })
    }

    var activeProject: Project? {
        projects.first(where: { project in
            project.sessions.contains(where: { $0.id == activeSessionId })
        }) ?? projects.first
    }

    func selectSession(id: UUID) {
        activeSessionId = id
        syncActiveSession()
    }

    func toggleProjectExpansion(id: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == id }) else { return }
        projects[projectIndex].isExpanded.toggle()
        persistProjects()
    }

    @discardableResult
    func registerProject(directoryPath: String) -> ProjectRegistrationResult {
        guard !directoryPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .invalidPath
        }

        let normalizedPath = Self.normalizeDirectoryPath(directoryPath)
        guard !normalizedPath.isEmpty else { return .invalidPath }

        if projects.contains(where: { Self.normalizeDirectoryPath($0.directoryPath) == normalizedPath }) {
            return .duplicate
        }

        projects.append(Project.sidebarRoot(directoryPath: normalizedPath))
        persistProjects()

        return .added
    }

    func replaceSessions(
        _ sessions: [Session],
        inProjectWithId projectId: UUID? = nil,
        activeSessionId: UUID?
    ) {
        guard let projectIndex = indexForProject(id: projectId) else { return }

        projects[projectIndex].sessions = sessions
        self.activeSessionId = activeSessionId ?? sessions.first?.id
        syncActiveSession()
    }

    private func indexForProject(id: UUID?) -> Int? {
        if let id {
            return projects.firstIndex(where: { $0.id == id })
        }

        return projects.indices.first
    }

    private func syncActiveSession() {
        if activeSessionId == nil {
            activeSessionId = projects
                .flatMap(\.sessions)
                .first(where: { $0.isActive })?
                .id ?? projects.first?.sessions.first?.id
        }

        guard let activeSessionId else { return }

        for projectIndex in projects.indices {
            for sessionIndex in projects[projectIndex].sessions.indices {
                projects[projectIndex].sessions[sessionIndex].isActive =
                    projects[projectIndex].sessions[sessionIndex].id == activeSessionId
            }
        }
    }

    private func persistProjects() {
        guard let userDefaults else { return }

        let storedProjects = projects.compactMap { project -> StoredProject? in
            let normalizedPath = Self.normalizeDirectoryPath(project.directoryPath)
            guard normalizedPath != projectRootPath else { return nil }

            return StoredProject(
                directoryPath: normalizedPath,
                isExpanded: project.isExpanded
            )
        }

        if let data = try? JSONEncoder().encode(storedProjects) {
            userDefaults.set(data, forKey: Self.storedProjectsKey)
        }
    }

    private static func initialProjects(
        projectRootPath: String,
        userDefaults: UserDefaults
    ) -> [Project] {
        let rootProject = Project.sidebarRoot(directoryPath: projectRootPath)
        let storedProjects = loadStoredProjects(from: userDefaults)

        guard !storedProjects.isEmpty else {
            return [rootProject]
        }

        var seenPaths = Set([projectRootPath])
        var projects = [rootProject]

        for storedProject in storedProjects {
            let normalizedPath = normalizeDirectoryPath(storedProject.directoryPath)
            guard seenPaths.insert(normalizedPath).inserted else { continue }

            projects.append(
                Project(
                    name: Project.defaultName(for: normalizedPath),
                    sessions: [],
                    isExpanded: storedProject.isExpanded,
                    directoryPath: normalizedPath
                )
            )
        }

        return projects
    }

    private static func loadStoredProjects(from userDefaults: UserDefaults) -> [StoredProject] {
        guard let data = userDefaults.data(forKey: storedProjectsKey) else { return [] }
        return (try? JSONDecoder().decode([StoredProject].self, from: data)) ?? []
    }

    private static func normalizeDirectoryPath(_ directoryPath: String) -> String {
        let expandedPath = (directoryPath as NSString).expandingTildeInPath
        return URL(fileURLWithPath: expandedPath).standardizedFileURL.path
    }
}

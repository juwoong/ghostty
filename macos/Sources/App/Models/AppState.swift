import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var projects: [Project]
    @Published var activeSessionId: UUID?

    init(projects: [Project] = Project.sampleData, activeSessionId: UUID? = nil) {
        self.projects = projects
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
        })
    }

    func selectSession(id: UUID) {
        activeSessionId = id
        syncActiveSession()
    }

    func toggleProjectExpansion(id: UUID) {
        guard let projectIndex = projects.firstIndex(where: { $0.id == id }) else { return }
        projects[projectIndex].isExpanded.toggle()
    }

    private func syncActiveSession() {
        guard let activeSessionId else { return }

        for projectIndex in projects.indices {
            for sessionIndex in projects[projectIndex].sessions.indices {
                projects[projectIndex].sessions[sessionIndex].isActive =
                    projects[projectIndex].sessions[sessionIndex].id == activeSessionId
            }
        }
    }
}

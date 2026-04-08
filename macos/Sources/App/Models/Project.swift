import Foundation

struct Project: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var sessions: [Session]
    var isExpanded: Bool
    var directoryPath: String

    init(
        id: UUID = UUID(),
        name: String,
        sessions: [Session] = [],
        isExpanded: Bool = true,
        directoryPath: String
    ) {
        self.id = id
        self.name = name
        self.sessions = sessions
        self.isExpanded = isExpanded
        self.directoryPath = directoryPath
    }
}

extension Project {
    static func defaultName(for directoryPath: String) -> String {
        let url = URL(fileURLWithPath: directoryPath)
        return url.lastPathComponent.isEmpty ? directoryPath : url.lastPathComponent
    }

    static func sidebarRoot(directoryPath: String) -> Project {
        return Project(
            name: defaultName(for: directoryPath),
            sessions: [],
            isExpanded: true,
            directoryPath: directoryPath
        )
    }
}

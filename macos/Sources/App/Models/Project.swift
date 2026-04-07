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
    static var sampleData: [Project] {
        [
            Project(
                name: "ghostty",
                sessions: [
                    Session(name: "main", agentState: .idle),
                    Session(name: "phase1-layout", agentState: .thinking, isActive: true),
                    Session(name: "review-notes", agentState: .waitingInput),
                ],
                isExpanded: true,
                directoryPath: "/Users/juwoong/gudos/ghostty"
            ),
            Project(
                name: "playground",
                sessions: [
                    Session(name: "main", agentState: .toolRunning),
                    Session(name: "port-check", agentState: .error),
                ],
                isExpanded: false,
                directoryPath: "/Users/juwoong/gudos/playground"
            ),
        ]
    }
}

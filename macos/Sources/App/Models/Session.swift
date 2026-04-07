import Foundation

enum AgentState: String, CaseIterable, Codable {
    case idle
    case thinking
    case waitingInput
    case toolRunning
    case error
}

struct Session: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var agentState: AgentState
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        agentState: AgentState = .idle,
        isActive: Bool = false
    ) {
        self.id = id
        self.name = name
        self.agentState = agentState
        self.isActive = isActive
    }
}

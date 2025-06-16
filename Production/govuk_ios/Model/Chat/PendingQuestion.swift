import Foundation

struct PendingQuestion: Codable {
    enum CodingKeys: String, CodingKey {
        case answerUrl = "answer_url"
        case conversationId = "conversation_id"
        case createdAt = "created_at"
        case id
        case message
    }

    let answerUrl: String
    let conversationId: String
    let createdAt: String
    let id: String
    let message: String
}

import Foundation

struct AnsweredQuestion: Codable {
    enum CodingKeys: String, CodingKey {
        case answer
        case conversationId = "conversation_id"
        case createdAt = "created_at"
        case id
        case message
    }

    let answer: Answer
    let conversationId: String
    let createdAt: String
    let id: String
    let message: String
}

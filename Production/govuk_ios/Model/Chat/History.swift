import Foundation

struct History: Codable {
    enum CodingKeys: String, CodingKey {
        case pendingQuestion = "pending_question"
        case answeredQuestions = "answered_questions"
        case createdAt = "created_at"
        case id
    }

    let pendingQuestion: PendingQuestion?
    let answeredQuestions: [AnsweredQuestion]
    let createdAt: String
    let id: String
}

import Foundation

@testable import govuk_ios

extension Answer {
    static var answeredAnswer: Answer {
        arrange()
    }

    static var pendingAnswer: Answer {
        arrange(createdAt: nil,
                id: nil,
                message: nil,
                sources: nil)
    }

    static func arrange(createdAt: String? = "2025-06-06T10:28:37+01:00",
                        id: String? = "166ddfa3-6698-43a5-ac7b-de1448dbc685",
                        message: String? = "expectedMessage",
                        sources: [Source]? = []) -> Answer {
        .init(createdAt: createdAt,
              id: id,
              message: message,
              sources: sources)
    }
}

extension PendingQuestion {
    static var pendingQuestion: PendingQuestion {
        arrange()
    }

    static func arrange(answerURL: String = "https://chat.integration.publishing.service.gov.uk",
                        conversationId: String = "930634c7-d453-41cb-beda-ecec6f8601f4",
                        createdAt: String = "2025-06-06T11:40:06+01:00",
                        id: String = "expectedPendingQuestionId",
                        message: String = "expectedQuestion") -> PendingQuestion {
        .init(answerUrl: answerURL,
              conversationId: conversationId,
              createdAt: createdAt,
              id: id,
              message: message)
    }
}

extension History {
    static let history = History(
        pendingQuestion: .pendingQuestion,
        answeredQuestions: [
            AnsweredQuestion(
                answer: .answeredAnswer,
                conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
                createdAt: "2025-06-06T11:40:06+01:00",
                id: "eded40d9-2837-4d67-8a45-1ac42da5826d",
                message: "expectedQuestion")],
        createdAt: "2025-06-06T11:40:06+01:00",
        id: "930634c7-d453-41cb-beda-ecec6f8601f4"
    )
}


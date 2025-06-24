import Foundation
import Testing

@testable import govuk_ios

@Suite
struct ChatServiceTests {

    @Test
    func askQuestion_pollsForAnswer() async throws {
        let mockChatServiceClient = MockChatServiceClient()
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            maxRetryCount: 3,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
        mockChatServiceClient._stubbedFetchAnswerResults = [
            .success(.pendingAnswer),
            .success(.answeredAnswer)
        ]

        let result = await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let answerResult = try #require(try? result.get())
        #expect(answerResult.id == "166ddfa3-6698-43a5-ac7b-de1448dbc685")
    }

    @Test func askQuestion_exceedsRetries_returnsExpectedError() async throws {
        let mockChatServiceClient = MockChatServiceClient()
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            maxRetryCount: 3,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
        mockChatServiceClient._stubbedFetchAnswerResults = [
            .success(.pendingAnswer),
            .success(.pendingAnswer),
            .success(.pendingAnswer),
            .success(.answeredAnswer)
        ]

        let result = await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        #expect((try? result.get()) == nil)
        let error = try #require(result.getError() as? ChatError)
        #expect(error == .maxRetriesExceeded)
    }

    @Test
    func ask_question_returnsExpectedError() async throws {
        let mockChatServiceClient = MockChatServiceClient()
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            maxRetryCount: 0,
            retryInterval: 0.2
        )
        
        mockChatServiceClient._stubbedAskQuestionResult = .failure(ChatError.networkUnavailable)
        let result = await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        #expect((try? result.get()) == nil)
        let error = try #require(result.getError() as? ChatError)
        #expect(error == .networkUnavailable)
    }

    @Test
    func ask_question_polling_returnsExpectedError() async throws {
        let mockChatServiceClient = MockChatServiceClient()
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            maxRetryCount: 2,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
        mockChatServiceClient._stubbedFetchAnswerResults = [
            .failure(ChatError.apiUnavailable)
        ]

        let result = await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        #expect((try? result.get()) == nil)
        let error = try #require(result.getError() as? ChatError)
        #expect(error == .apiUnavailable)
    }

    @Test
    func chatHistory_returnsExpectedResult() async throws {
        let mockChatServiceClient = MockChatServiceClient()
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            maxRetryCount: 3,
            retryInterval: 0.2
        )

        let expectedId = "eded40d9-2837-4d67-8a45-1ac42da5826d"
        let history = History(
            pendingQuestion: .pendingQuestion,
            answeredQuestions: [
                AnsweredQuestion(
                    answer: .answeredAnswer,
                    conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
                    createdAt: "2025-06-06T11:40:06+01:00",
                    id: expectedId,
                    message: "expectedQuestion")],
            createdAt: "2025-06-06T11:40:06+01:00",
            id: "930634c7-d453-41cb-beda-ecec6f8601f4")

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
        mockChatServiceClient._stubbedFetchHistoryResult = .success(history)

        // Ask question to create conversationId
        await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume()
                }
            )
        }
        let result = await withCheckedContinuation { continuation in
            sut.chatHistory(
                conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let historyResult = try #require(try? result.get())
        #expect(historyResult.count == 1)
        #expect(historyResult.first?.id == expectedId)
    }

    @Test
    func chatHistory_noConversationId_returnsEmptyArray() async throws {
        let mockChatServiceClient = MockChatServiceClient()
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            maxRetryCount: 3,
            retryInterval: 0.2
        )

        let expectedId = "eded40d9-2837-4d67-8a45-1ac42da5826d"
        let history = History(
            pendingQuestion: .pendingQuestion,
            answeredQuestions: [
                AnsweredQuestion(
                    answer: .answeredAnswer,
                    conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
                    createdAt: "2025-06-06T11:40:06+01:00",
                    id: expectedId,
                    message: "expectedQuestion")],
            createdAt: "2025-06-06T11:40:06+01:00",
            id: "930634c7-d453-41cb-beda-ecec6f8601f4")

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
        mockChatServiceClient._stubbedFetchHistoryResult = .success(history)

        let result = await withCheckedContinuation { continuation in
            sut.chatHistory(
                conversationId: nil,
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let historyResult = try #require(try? result.get())
        #expect(historyResult.count == 0)
    }
}

private extension Answer {
    static let pendingAnswer = Answer(createdAt: nil,
                                      id: nil,
                                      message: nil,
                                      sources: nil)

    static let answeredAnswer = Answer(createdAt: "2025-06-06T10:28:37+01:00",
                                       id: "166ddfa3-6698-43a5-ac7b-de1448dbc685",
                                       message: "expectedMessage",
                                       sources: [])
}

private extension PendingQuestion {
    static let pendingQuestion = PendingQuestion(
        answerUrl: "https://chat.integration.publishing.service.gov.uk",
        conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
        createdAt: "2025-06-06T11:40:06+01:00",
        id: "eded40d9-2837-4d67-8a45-1ac42da5826d",
        message: "expectedQuestion"
    )
}

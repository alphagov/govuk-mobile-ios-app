import Foundation
import Testing

@testable import govuk_ios

@Suite
final class ChatServiceTests {

    var mockChatServiceClient: MockChatServiceClient!
    var mockChatRepository: MockChatRespository!

    init() {
        mockChatServiceClient = MockChatServiceClient()
        mockChatRepository = MockChatRespository()
    }

    deinit {
        mockChatServiceClient = nil
        mockChatRepository = nil
    }

    @Test
    func askQuestion_savesConversationId() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            maxRetryCount: 1,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
        mockChatServiceClient._stubbedFetchAnswerResults = [
            .success(.pendingAnswer)
        ]

        await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume()
                }
            )
        }

        #expect(sut.currentConversationId == PendingQuestion.pendingQuestion.conversationId)
    }

    @Test
    func askQuestion_pollsForAnswer() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
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
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
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
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
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
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
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
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            maxRetryCount: 3,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedFetchHistoryResult = .success(.history)

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
        #expect(historyResult.first?.id == History.history.answeredQuestions.first?.id)
    }

    @Test
    func chatHistory_noConversationId_returnsEmptyArray() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            maxRetryCount: 1,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedFetchHistoryResult = .success(.history)

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

    @Test func chatHistory_returnsExpectedError() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            maxRetryCount: 1,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedFetchHistoryResult = .failure(ChatError.apiUnavailable)

        let result = await withCheckedContinuation { continuation in
            sut.chatHistory(
                conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
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
    func clearHistory_setsConversationIdToNil() {
        mockChatRepository._conversationId = "existing_id"
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            maxRetryCount: 1,
            retryInterval: 0.2
        )

        sut.clearHistory()
        #expect(mockChatRepository.fetchConversation() == nil)
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

private extension History {
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

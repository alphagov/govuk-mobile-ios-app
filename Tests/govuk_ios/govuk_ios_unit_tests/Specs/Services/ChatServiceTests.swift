import Foundation
import Testing

@testable import govuk_ios

@Suite
final class ChatServiceTests {

    var mockChatServiceClient: MockChatServiceClient!
    var mockChatRepository: MockChatRespository!
    var mockConfigService: MockAppConfigService!

    init() {
        mockChatServiceClient = MockChatServiceClient()
        mockChatRepository = MockChatRespository()
        mockConfigService = MockAppConfigService()
    }

    deinit {
        mockChatServiceClient = nil
        mockChatRepository = nil
        mockConfigService = nil
    }

    @Test
    func askQuestion_savesConversationId() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
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
    func askQuestion_returnsExpectedValue() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)

        let result = await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let pendingQuestionResult = try #require(try? result.get())
        #expect(pendingQuestionResult.id == "expectedPendingQuestionId")
    }

    @Test
    func ask_question_returnsExpectedError() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
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
        let error = try #require(result.getError())
        #expect(error == .networkUnavailable)
    }

    @Test
    func pollForAnswer_returnsExpectedResult() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedFetchAnswerResults = [
            .success(.pendingAnswer),
            .success(.pendingAnswer),
            .success(.pendingAnswer),
            .success(.answeredAnswer)
        ]

        let result = await withCheckedContinuation { continuation in
            sut.pollForAnswer(
                .pendingQuestion,
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        let answerResult = try #require(try? result.get())
        #expect(answerResult.message == "expectedMessage")
    }


    @Test
    func pollForAnswer_returnsExpectedError() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            retryInterval: 0.2
        )

        mockChatServiceClient._stubbedFetchAnswerResults = [
            .failure(ChatError.apiUnavailable)
        ]

        let result = await withCheckedContinuation { continuation in
            sut.pollForAnswer(
                .pendingQuestion,
                completion: { result in
                    continuation.resume(returning: result)
                }
            )
        }

        #expect((try? result.get()) == nil)
        let error = try #require(result.getError())
        #expect(error == .apiUnavailable)
    }

    @Test
    func chatHistory_returnsExpectedResult() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
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
        #expect(historyResult.answeredQuestions.count == 1)
        #expect(historyResult.answeredQuestions.first?.id ==
                History.history.answeredQuestions.first?.id)
    }

    @Test func chatHistory_returnsExpectedError() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
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
        let error = try #require(result.getError())
        #expect(error == .apiUnavailable)
    }

    @Test
    func clearHistory_setsConversationIdToNil() {
        mockChatRepository._conversationId = "existing_id"
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            maxRetryCount: 1,
            retryInterval: 0.2
        )

        sut.clearHistory()
        #expect(mockChatRepository.fetchConversation() == nil)
    }

    @Test
    func isEnabled_featureUnavailable_returnsFalse() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            maxRetryCount: 1,
            retryInterval: 0.2
        )
        mockConfigService.features = []

        #expect(sut.isEnabled == false)
    }

    @Test
    func isEnabled_featureAvailable_returnsTrue() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            maxRetryCount: 1,
            retryInterval: 0.2
        )
        mockConfigService.features = [.chat]

        #expect(sut.isEnabled == true)
    }
}

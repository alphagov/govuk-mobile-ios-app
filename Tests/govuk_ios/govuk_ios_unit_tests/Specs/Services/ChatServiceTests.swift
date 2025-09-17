import Foundation
import Testing

@testable import govuk_ios

@Suite
final class ChatServiceTests {

    var mockChatServiceClient: MockChatServiceClient!
    var mockChatRepository: MockChatRespository!
    var mockConfigService: MockAppConfigService!
    var mockUserDefaultsService: MockUserDefaultsService!
    var mockAuthenticationService: MockAuthenticationService!

    init() {
        mockChatServiceClient = MockChatServiceClient()
        mockChatRepository = MockChatRespository()
        mockConfigService = MockAppConfigService()
        mockConfigService._stubbedChatPollIntervalSeconds = 0.2
        mockUserDefaultsService = MockUserDefaultsService()
        mockAuthenticationService = MockAuthenticationService()
    }

    deinit {
        mockChatServiceClient = nil
        mockChatRepository = nil
        mockConfigService = nil
        mockUserDefaultsService = nil
    }

    @Test
    func askQuestion_savesConversationId() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
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
            userDefaultsService: mockUserDefaultsService
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
            userDefaultsService: mockUserDefaultsService
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
    func askQuestion_retryAction_asksQuestionAgain() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        mockChatServiceClient._stubbedAskQuestionResult = .failure(ChatError.authenticationError)
        let result = await withCheckedContinuation { continuation in
            sut.askQuestion(
                "expectedQuestion",
                completion: { result in
                    guard result.getError() == nil else {
                        self.mockChatServiceClient._stubbedAskQuestionResult = .success(.pendingQuestion)
                        sut.retryAction?()
                        return
                    }
                    continuation.resume(returning: result)
                }
            )
        }
        let pendingQuestionResult = try #require(try? result.get())
        #expect(pendingQuestionResult.id == "expectedPendingQuestionId")
    }

    @Test
    func pollForAnswer_returnsExpectedResult() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
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
            userDefaultsService: mockUserDefaultsService
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
    func pollForAnswer_retryAction_pollsAgain() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        mockChatServiceClient._stubbedFetchAnswerResults = [
            .failure(ChatError.authenticationError)
        ]

        let result = await withCheckedContinuation { continuation in
            sut.pollForAnswer(
                .pendingQuestion,
                completion: { result in
                    guard result.getError() == nil else {
                        self.mockChatServiceClient._stubbedFetchAnswerResults = [
                            .success(.answeredAnswer)
                        ]
                        sut.retryAction?()
                        return
                    }
                    continuation.resume(returning: result)
                }
            )
        }

        let answerResult = try #require(try? result.get())
        #expect(answerResult.message == "expectedMessage")
    }

    @Test
    func chatHistory_returnsExpectedResult() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
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
            userDefaultsService: mockUserDefaultsService
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
    func chatHistory_retryAction_callHistoryAgain() async throws {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        mockChatServiceClient._stubbedFetchHistoryResult = .failure(ChatError.authenticationError)

        let result = await withCheckedContinuation { continuation in
            sut.chatHistory(
                conversationId: "930634c7-d453-41cb-beda-ecec6f8601f4",
                completion: { result in
                    guard result.getError() == nil else {
                        self.mockChatServiceClient._stubbedFetchHistoryResult = .success(.history)
                        sut.retryAction?()
                        return
                    }
                    continuation.resume(returning: result)
                }
            )
        }

        let historyResult = try #require(try? result.get())
        #expect(historyResult.answeredQuestions.count == 1)
        #expect(historyResult.answeredQuestions.first?.id ==
                History.history.answeredQuestions.first?.id)
    }

    @Test
    func clearHistory_setsConversationIdToNil() {
        mockChatRepository._conversationId = "existing_id"
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
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
            userDefaultsService: mockUserDefaultsService
        )
        mockConfigService.features = []

        #expect(sut.isEnabled == false)
    }

    @Test
    func isEnabled_featureAvailableTestNotActive_returnsTrue() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )
        mockConfigService.features = [.chat]

        #expect(sut.isEnabled == false)
    }

    @Test
    func isEnabled_featureUnavailableTestActive_returnsTrue() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )
        mockConfigService.features = [.chatTestActive]

        #expect(sut.isEnabled == false)
    }

    @Test
    func isEnabled_featureAvailableTestActive_returnsTrue() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )
        mockConfigService.features = [.chat, .chatTestActive]

        #expect(sut.isEnabled == true)
    }

    @Test
    func setChatOnboarded_updatesChatOnboardingSeen_returnsTrue() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(!sut.chatOnboardingSeen)
        sut.setChatOnboarded()
        #expect(sut.chatOnboardingSeen)
    }

    @Test
    func chatOptedIn_updatesChatOptedIn_returnsTrue() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(sut.chatOptedIn == nil)
        sut.chatOptedIn = true
        #expect(sut.chatOptedIn!)
    }

    @Test
    func chatOptedIn_updatesChatOptedIn_returnsFalse() {
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(sut.chatOptedIn == nil)
        sut.chatOptedIn = false
        #expect(!sut.chatOptedIn!)
    }

    @Test
    func chatOptInAvailable_featureAvailable_returnsTrue() {
        mockConfigService.features = [.chatOptIn]
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(sut.chatOptInAvailable == true)
    }

    @Test
    func chatTestActive_featureUnavailable_returnFalse() {
        mockConfigService.features = []
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(sut.chatTestActive == false)
    }

    @Test
    func chatTestActive_featureAvailable_returnsTrue() {
        mockConfigService.features = [.chatTestActive]
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(sut.chatTestActive == true)
    }

    @Test
    func chatOptInAvailable_featureUnavailable_returnFalse() {
        mockConfigService.features = []
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )

        #expect(sut.chatOptInAvailable == false)
    }

    @Test
    func chatUrls_returnExpectedValues() {
        mockConfigService._stubbedChatUrls = .init(
            termsAndConditions: URL(string: "https://example.com/termsAndConditions")!,
            privacyNotice: URL(string: "https://example.com/privacy")!,
            about: URL(string: "https://example.com/about")!,
            feedback: URL(string: "https://example.com/feedback")!
        )
        
        let sut = ChatService(
            serviceClient: mockChatServiceClient,
            chatRepository: mockChatRepository,
            configService: mockConfigService,
            userDefaultsService: mockUserDefaultsService
        )
        
        #expect(sut.about == mockConfigService.chatUrls?.about)
        #expect(sut.termsAndConditions == mockConfigService.chatUrls?.termsAndConditions)
        #expect(sut.privacyPolicy == mockConfigService.chatUrls?.privacyNotice)
        #expect(sut.feedback == mockConfigService.chatUrls?.feedback)
    }
}

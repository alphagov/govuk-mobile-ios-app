import Foundation
import Testing
import GOVKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
struct ChatViewModelTests {

    @Test
    func askQuestion_success_createsCorrectCellModels() async {
        let mockChatService = MockChatService()
        mockChatService._stubbedQuestionResult = .success(.pendingQuestion)
        mockChatService._stubbedAnswerResults = [.success(.answeredAnswer)]
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )
        sut.latestQuestion = "This is the question"
        sut.askQuestion()

        #expect(sut.cellModels.count == 2)
        #expect(sut.cellModels.first?.type == .question)
        #expect(sut.cellModels.last?.type == .answer)
        #expect(sut.latestQuestion == "")
    }

    @Test
    func askQuestion_tracksAskAndResponseEvents() async {
        let mockChatService = MockChatService()
        let mockAnalyticsService = MockAnalyticsService()
        mockChatService._stubbedQuestionResult = .success(.pendingQuestion)
        mockChatService._stubbedAnswerResults = [.success(.answeredAnswer)]
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { _ in }
        )
        sut.latestQuestion = "This is the question"
        sut.askQuestion()

        #expect(mockAnalyticsService._trackedEvents.count == 2)
        #expect(
            mockAnalyticsService
                ._trackedEvents.first?.params?["text"] as? String == ""
        )
        #expect(
            mockAnalyticsService
                ._trackedEvents.last?.params?["text"] as? String == "Chat Question Answer Returned"
        )
    }

    @Test
    func askQuestion_answer_failure_callsHandleError() {
        let mockChatService = MockChatService()
        mockChatService._stubbedQuestionResult = .success(.pendingQuestion)
        mockChatService._stubbedAnswerResults = [.failure(ChatError.apiUnavailable)]
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { error in
                chatError = error
            }
        )
        sut.latestQuestion = "This is the question"

        sut.askQuestion()

        #expect(sut.cellModels.count == 1)
        #expect(sut.cellModels.first?.type == .question)
        #expect(chatError == .apiUnavailable)
    }

    @Test
    func askQuestion_question_failure_callsHandleError() {
        let mockChatService = MockChatService()
        mockChatService._stubbedQuestionResult = .failure(ChatError.pageNotFound)
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { error in
                chatError = error
            }
        )
        sut.latestQuestion = "This is the question"

        sut.askQuestion()

        #expect(chatError == .pageNotFound)
    }

    @Test
    func askQuestionWithPII_generatesErrorText() {
        let mockChatService = MockChatService()
        let mockAnalyticsService = MockAnalyticsService()
        mockChatService._stubbedQuestionResult = .failure(ChatError.pageNotFound)
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { error in
                chatError = error
            }
        )
        sut.latestQuestion = "My e-mail is steve@apple.com"

        #expect(sut.errorText == nil)
        sut.askQuestion()

        #expect(sut.cellModels.count == 0)
        #expect(chatError == nil)
        #expect(sut.errorText != nil)
        #expect(!sut.latestQuestion.isEmpty)
        #expect(mockAnalyticsService._trackedEvents.count == 0)
    }

    @Test
    func askQuestion_validationError_generatesErrorText() {
        let mockChatService = MockChatService()
        mockChatService._stubbedQuestionResult = .failure(ChatError.validationError)
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { error in
                chatError = error
            }
        )
        sut.latestQuestion = "This is the question"

        #expect(sut.errorText == nil)
        sut.askQuestion()

        #expect(chatError == nil)
        #expect(sut.errorText != nil)
        #expect(!sut.latestQuestion.isEmpty)
    }

    @Test
    func loadHistory_success_createsCorrectCellModels() throws {
        let mockChatService = MockChatService()
        let conversationId = "conversationId"
        let createdAt = "\(Date())"
        let answerOne = Answer(
            createdAt: createdAt,
            id: "12345",
            message: "This is answer one",
            sources: nil
        )
        let answerTwo = Answer(
            createdAt: createdAt,
            id: "67890",
            message: "This is answer two",
            sources: nil
        )

        let aqOne = AnsweredQuestion(
            answer: answerOne,
            conversationId: conversationId,
            createdAt: createdAt,
            id: "1",
            message: "First question"
        )

        let aqTwo = AnsweredQuestion(
            answer: answerTwo,
            conversationId: conversationId,
            createdAt: createdAt,
            id: "2",
            message: "Next question"
        )

        let pendingQuestion = PendingQuestion(
            answerUrl: "https://www.example.com",
            conversationId: conversationId,
            createdAt: createdAt,
            id: "78910",
            message: "This is the pending question"
        )

        let history = History(
            pendingQuestion: pendingQuestion,
            answeredQuestions: [aqOne, aqTwo],
            createdAt: createdAt,
            id: "4456")

        mockChatService._stubbedConversationId = "12345"
        mockChatService._stubbedHistoryResult = .success(history)
        mockChatService._stubbedQuestionResult = .success(.pendingQuestion)

        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )

        sut.loadHistory()
        try #require(sut.cellModels.count == 8)
        #expect(sut.cellModels[0].type == .intro)
        #expect(sut.cellModels[1].type == .intro)
        #expect(sut.cellModels[2].type == .intro)
        #expect(sut.cellModels[3].type == .question)
        #expect(sut.cellModels[4].type == .answer)
        #expect(sut.cellModels[5].type == .question)
        #expect(sut.cellModels[6].type == .answer)
        #expect(sut.cellModels[7].type == .question)
    }

    @Test
    func loadHistory_error_callsHandleError() {
        let mockChatService = MockChatService()
        mockChatService._stubbedConversationId = "12345"
        mockChatService._stubbedHistoryResult = .failure(ChatError.apiUnavailable)
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { error in
                chatError = error
            }
        )

        sut.loadHistory()
        #expect(sut.cellModels.count == 0)
        #expect(chatError == .apiUnavailable)
    }

    @Test
    func loadHistory_pageNotFoundError_clearsConversation() {
        let mockChatService = MockChatService()
        mockChatService._stubbedConversationId = "12345"
        mockChatService._stubbedHistoryResult = .failure(ChatError.pageNotFound)
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { error in
                chatError = error
            }
        )

        #expect(mockChatService.currentConversationId == "12345")
        sut.loadHistory()
        #expect(sut.cellModels.count == 0)
        #expect(chatError == nil)
        #expect(mockChatService.currentConversationId == nil)
    }

    @Test
    func newChat_clearsHistory() {
        let mockChatService = MockChatService()

        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )

        sut.cellModels = [.gettingAnswer]

        sut.newChat()
        #expect(mockChatService._clearHistoryCalled)
    }

    @Test
    func openAboutURL_opensURLAndtracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatViewModel(
                chatService: MockChatService(),
                analyticsService: mockAnalyticsService,
                openURLAction: { _ in confirmation() },
                handleError: { _ in }
            )

            sut.openAboutURL()
            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "About")
        }
    }

    @Test
    func openFeedbackURL_opensURLAndtracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatViewModel(
                chatService: MockChatService(),
                analyticsService: mockAnalyticsService,
                openURLAction: { _ in confirmation() },
                handleError: { _ in }
            )

            sut.openFeedbackURL()
            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Give feedback")
        }
    }

    @Test
    func openPrivacyURL_opensURLAndtracksEvent() async {
        await confirmation() { confirmation in
            let mockAnalyticsService = MockAnalyticsService()
            let sut = ChatViewModel(
                chatService: MockChatService(),
                analyticsService: mockAnalyticsService,
                openURLAction: { _ in confirmation() },
                handleError: { _ in }
            )

            sut.openPrivacyURL()
            #expect(mockAnalyticsService._trackedEvents.count == 1)
            #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Privacy notice")
        }
    }

    @Test
    func trackMenuClearChatTap_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { _ in }
        )

        sut.trackMenuClearChatTap()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Clear chat")
    }

    @Test
    func trackMenuClearChatConfirmTap_tracksEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { _ in }
        )

        sut.trackMenuClearChatConfirmTap()
        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Yes, clear chat")
    }

    @Test
    func updateCharacterCount_remainingCharacter_updatesWarningText() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { _ in }
        )
        sut.latestQuestion = """
            Lorem ipsum dolor sit amet consectetur adipiscing
            elit quisque faucibus ex sapien vitae pellentesque
            sem placerat in id cursus mi pretium tellus duis
            convallis tempus leo eu aenean sed diam urna tempor
            pulvinar vivamus fringillsss lacus nec metus biben
        """

        #expect(sut.warningText == nil)
        sut.updateCharacterCount()
        #expect(sut.warningText != nil)
        #expect(sut.errorText == nil)
    }

    @Test
    func updateCharacterCount_tooManyCharacter_updatesErrorText() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { _ in }
        )
        sut.latestQuestion = """
            Lorem ipsum dolor sit amet consectetur adipiscing
            elit quisque faucibus ex sapien vitae pellentesque
            sem placerat in id cursus mi pretium tellus duis
            convallis tempus leo eu aenean sed diam urna tempor
            pulvinar vivamus fringillsss lacus nec metus biben
            pulvinar vivamus fringillsss lacus nec metus biben
            pulvinar vivamus fringillsss lacus nec metus biben
        """

        #expect(sut.errorText == nil)
        sut.updateCharacterCount()
        #expect(sut.errorText != nil)
        #expect(sut.warningText == nil)
    }

    @Test
    func updateCharacterCount_setsWarningAndErrorTextToNil() {
        let mockAnalyticsService = MockAnalyticsService()
        let sut = ChatViewModel(
            chatService: MockChatService(),
            analyticsService: mockAnalyticsService,
            openURLAction: { _ in },
            handleError: { _ in }
        )
        sut.latestQuestion = "Lorem ipsum dolor sit amet consectetur adipiscing"

        sut.updateCharacterCount()
        #expect(sut.errorText == nil)
        #expect(sut.warningText == nil)
    }
}

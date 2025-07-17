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
        mockChatService._stubbedAnswerResult = .success(.answeredAnswer)
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )
        sut.latestQuestion = "This is the question"
        sut.askQuestion()

        print("Cell models = \(sut.cellModels)")
        #expect(sut.cellModels.count == 2)
        #expect(sut.cellModels.first?.type == .question)
        #expect(sut.cellModels.last?.type == .answer)
        #expect(sut.latestQuestion == "")
    }

    @Test
    func askQuestion_failure_callsHandleError() {
        let mockChatService = MockChatService()
        mockChatService._stubbedQuestionResult = .success(.pendingQuestion)
        mockChatService._stubbedAnswerResult = .failure(ChatError.apiUnavailable)
        var chatError: ChatError?
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { error in
                chatError = error as? ChatError
            }
        )
        sut.latestQuestion = "This is the question"

        sut.askQuestion()

        #expect(sut.cellModels.count == 1)
        #expect(sut.cellModels.first?.type == .question)
        #expect(chatError == .apiUnavailable)
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

        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )

        sut.loadHistory()
        try #require(sut.cellModels.count == 5)
        #expect(sut.cellModels[0].type == .question)
        #expect(sut.cellModels[1].type == .answer)
        #expect(sut.cellModels[2].type == .question)
        #expect(sut.cellModels[3].type == .answer)
        #expect(sut.cellModels[4].type == .question)
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
                chatError = error as? ChatError
            }
        )

        sut.loadHistory()
        #expect(sut.cellModels.count == 0)
        #expect(chatError == .apiUnavailable)
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
        #expect(sut.cellModels.isEmpty)
        #expect(mockChatService._clearHistoryCalled)
    }
}

import Foundation
import Testing
import GOVKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
struct ChatViewModelTests {

    @Test
    func askQuestion_success_createsCorrectCellModels() {
        let mockChatService = MockChatService()
        let answer = Answer(
            createdAt: "\(Date())",
            id: "12345",
            message: "This is the answer",
            sources: nil
        )

        mockChatService._stubbedAnswerResult = .success(answer)
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService()
        )
        sut.latestQuestion = "This is the question"

        sut.askQuestion()

        #expect(sut.cellModels.count == 2)
        #expect(sut.cellModels.first?.type == .question)
        #expect(sut.cellModels.last?.type == .answer)
    }

    @Test
    func askQuestion_failure_createsCorrectCellModels() {
        let mockChatService = MockChatService()
        mockChatService._stubbedAnswerResult = .failure(ChatError.apiUnavailable)
        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService()
        )
        sut.latestQuestion = "This is the question"

        sut.askQuestion()

        #expect(sut.cellModels.count == 2)
        #expect(sut.cellModels.first?.type == .question)
        #expect(sut.cellModels.last?.type == .error)
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

        mockChatService._stubbedHistoryResult = .success([aqOne, aqTwo])

        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService()
        )

        sut.loadHistory()
        try #require(sut.cellModels.count == 4)
        #expect(sut.cellModels[0].type == .question)
        #expect(sut.cellModels[1].type == .answer)
        #expect(sut.cellModels[2].type == .question)
        #expect(sut.cellModels[3].type == .answer)
    }

    @Test
    func loadHistory_error_createsCorrectCellModels() {
        let mockChatService = MockChatService()
        mockChatService._stubbedHistoryResult = .failure(ChatError.apiUnavailable)

        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService()
        )

        sut.loadHistory()
        #expect(sut.cellModels.count == 1)
        #expect(sut.cellModels.first?.type == .error)
    }

    @Test
    func newChat_clearsHistory() {
        let mockChatService = MockChatService()

        let sut = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService()
        )

        sut.cellModels = [.placeHolder]

        sut.newChat()
        #expect(sut.cellModels.isEmpty)
        #expect(mockChatService._clearHistoryCalled)
    }
}

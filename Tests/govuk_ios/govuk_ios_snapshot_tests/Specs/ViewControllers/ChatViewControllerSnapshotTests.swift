import Foundation
import XCTest
import SwiftUI


@testable import govuk_ios
@testable import GOVKitTestUtilities

final class ChatViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view,
            mode: .dark,
            navBarHidden: true
        )
    }

    private var view: some View {
        let mockChatService = MockChatService()
        let conversationId = "conversationId"
        let createdAt = "\(Date())"
        let sources: [Source] = [
            .init(
                title: "source 1",
                url: "http://www.source1.com"
            ),
            .init(
                title: "source 2",
                url: "http://www.source2.com"
            )
        ]

        let answer = Answer(
            createdAt: createdAt,
            id: "12345",
            message: "This is the answer",
            sources: sources
        )

        let answeredQuestion = AnsweredQuestion(
            answer: answer,
            conversationId: conversationId,
            createdAt: createdAt,
            id: "1",
            message: "This is the question"
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
            answeredQuestions: [answeredQuestion],
            createdAt: createdAt,
            id: "4456")

        mockChatService._stubbedConversationId = conversationId
        mockChatService._stubbedHistoryResult = .success(history)
        mockChatService._stubbedQuestionResult = .success(pendingQuestion)

        let viewModel = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )

        viewModel.cellModels.append(.gettingAnswer)

        return ChatView(viewModel: viewModel)
    }
}

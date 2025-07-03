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

        let viewModel = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService()
        )

        return ChatView(viewModel: viewModel)
    }
}

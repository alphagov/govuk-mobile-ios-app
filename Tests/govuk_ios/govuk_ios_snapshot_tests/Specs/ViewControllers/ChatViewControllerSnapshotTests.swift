import Foundation
import XCTest
import SwiftUI


@testable import govuk_ios
@testable import GOVKitTestUtilities

final class ChatViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(),
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_noSources_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(includeSources: false),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_noSources_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(includeSources: false),
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_showError_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(showError: true),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_showError_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view(showError: true),
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_generatingAnswer_light_rendersCorrectly() {
        let mockChatService = MockChatService()
        let conversationId = "conversationId"
        mockChatService._stubbedConversationId = conversationId
        // An authenticationError will prevent the history from loading on
        // view appearance
        mockChatService._stubbedQuestionResult = .failure(.authenticationError)

        let viewModel = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )
        viewModel.askQuestion()
        // With no history loading to create cellModels, modify the array
        // directly
        let model = ChatCellViewModel.gettingAnswer
        model.isVisible = true
        viewModel.cellModels = [ChatCellViewModel.gettingAnswer]

        let view = ChatView(viewModel: viewModel)
            .environment(\.isTesting, true)

        VerifySnapshotInNavigationController(
            view: view,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_generatingAnswer_dark_rendersCorrectly() {
        let mockChatService = MockChatService()
        let conversationId = "conversationId"
        mockChatService._stubbedConversationId = conversationId
        mockChatService._stubbedQuestionResult = .failure(.authenticationError)

        let viewModel = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )
        viewModel.askQuestion()

        let model = ChatCellViewModel.gettingAnswer
        model.isVisible = true
        viewModel.cellModels = [ChatCellViewModel.gettingAnswer]

        let view = ChatView(viewModel: viewModel)
            .environment(\.isTesting, true)

        VerifySnapshotInNavigationController(
            view: view,
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_markdown_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: markdownView(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_markdown_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: markdownView(),
            mode: .dark,
            navBarHidden: true
        )
    }

    private func view(showError: Bool = false,
                      includeSources: Bool = true) -> some View {
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
            sources: includeSources ? sources : nil
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

        if showError {
            viewModel.errorText = String.chat.localized("validationErrorText")
        }
        
        let view = ChatView(viewModel: viewModel)
            .environment(\.isTesting, true)
        return view
    }

    private func markdownView() -> some View {
        let mockChatService = MockChatService()
        let conversationId = "conversationId"
        let createdAt = "\(Date())"
        mockChatService._stubbedConversationId = conversationId
        // An authenticationError will prevent the history from loading on
        // view appearance
        mockChatService._stubbedQuestionResult = .failure(.authenticationError)

        let viewModel = ChatViewModel(
            chatService: mockChatService,
            analyticsService: MockAnalyticsService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )
        viewModel.askQuestion()
        // With no history loading to create cellModels, modify the array
        // directly

        let answer = Answer(
            createdAt: createdAt,
            id: "12345",
            message: """
                # Heading 1
                ## Heading 2
                ### Heading 3
                #### Heading 4
                ##### Heading 5
                ###### Heading 6
                * Bullet 1
                * Bullet 2
                1. Number 1
                2. Number 2
                """,
            sources: nil
        )

        let cellModel = ChatCellViewModel(answer: answer,
                                          openURLAction: { _ in },
                                          analyticsService: MockAnalyticsService())
        cellModel.isVisible = true
        viewModel.cellModels = [cellModel]

        return ChatView(viewModel: viewModel)
            .environment(\.isTesting, true)
    }
}

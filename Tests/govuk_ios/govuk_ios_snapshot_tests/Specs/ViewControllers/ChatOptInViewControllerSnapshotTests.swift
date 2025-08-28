import Foundation

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatOptInViewControllerSnapshotTests: SnapshotTestCase {
    func test_remainingCharacters_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = ChatOptInViewModel(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )
        let chatOptInView = ChatOptInView(viewModel: viewModel)

        VerifySnapshotInNavigationController(
            view: chatOptInView,
            mode: .light
        )
    }

    func test_remainingCharacters_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = ChatOptInViewModel(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )
        let chatOptInView = ChatOptInView(viewModel: viewModel)

        VerifySnapshotInNavigationController(
            view: chatOptInView,
            mode: .dark
        )
    }
}


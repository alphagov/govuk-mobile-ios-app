import Foundation

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatOffboardingViewControllerSnapshotTests: SnapshotTestCase {
    let viewControllerBuilder = ViewControllerBuilder()

    func test_loadInNavigationController_light_rendersCorrectly() {
        let chatOffboardingViewController = viewControllerBuilder.chatOffboarding(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: chatOffboardingViewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let chatOffboardingViewController = viewControllerBuilder.chatOffboarding(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: chatOffboardingViewController,
            mode: .dark
        )
    }
}


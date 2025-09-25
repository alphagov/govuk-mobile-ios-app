import Foundation

@testable import GOVKitTestUtilities
@testable import govuk_ios

final class ChatConsentOnboardingViewControllerSnapshotTests: SnapshotTestCase {
    let viewControllerBuilder = ViewControllerBuilder()

    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewController = viewControllerBuilder.chatConsentOnboarding(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            cancelOnboardingAction: { },
            completionAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewController = viewControllerBuilder.chatConsentOnboarding(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            cancelOnboardingAction: { },
            completionAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }
}


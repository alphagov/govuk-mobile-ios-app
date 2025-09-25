import Foundation
import UIKit
import GOVKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct ChatConsentOnboardingCoordinatorTests {
    @Test
    func start_setsChatConsentOnboardingViewController() throws {
        let mockChatService = MockChatService()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatConsentOnboardingController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatConsentOnboardingCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            cancelOnboardingAction: { },
            completionAction: { }
        )

        sut.start()
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
    }
}

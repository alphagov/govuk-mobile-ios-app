import Foundation
import UIKit
import GOVKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct ChatOptInCoordinatorTests {
    @Test
    func start_setsChatOptInCoordinatorViewController() {
        let mockChatService = MockChatService()
        mockChatService._stubbedChatOptInAvailable = true
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatOptInController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatOptInCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            coordinatorBuilder: CoordinatorBuilder.mock,
            analyticsService: MockAnalyticsService(),
            chatService: mockChatService,
            completionAction: { }
        )

        sut.start()
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
    }

    @Test
    func start_optedIn_callsCompletion() async {
        let mockChatService = MockChatService()
        mockChatService._stubbedChatOptInAvailable = true
        mockChatService.chatOptedIn = true
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatOptInController = expectedViewController
        let navigationController = UINavigationController()
        await confirmation() { confirmation in
            let sut = ChatOptInCoordinator(
                navigationController: navigationController,
                viewControllerBuilder: mockViewControllerBuilder,
                coordinatorBuilder: CoordinatorBuilder.mock,
                analyticsService: MockAnalyticsService(),
                chatService: mockChatService,
                completionAction: { confirmation() }
            )

            sut.start()
            #expect(navigationController.viewControllers.count == 0)
        }
    }
}

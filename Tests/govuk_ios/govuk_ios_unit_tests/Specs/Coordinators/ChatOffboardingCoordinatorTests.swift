import Foundation
import UIKit
import GOVKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct ChatOffboardingCoordinatorTests {
    @Test
    func start_setsChatOptInCoordinatorViewController() {
        let mockChatService = MockChatService()
        mockChatService._stubbedChatTestActive = false
        mockChatService.chatOptedIn = true
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatOffboardingController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatOffboardingCoordinator(
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
    func start_chatTestActive_callsCompletion() async {
        let mockChatService = MockChatService()
        mockChatService._stubbedChatTestActive = true
        mockChatService.chatOptedIn = false
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatOptInController = expectedViewController
        let navigationController = UINavigationController()
        await confirmation() { confirmation in
            let sut = ChatOffboardingCoordinator(
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

    @Test
    func start_chatTestInactiveOptedOut_callsCompletion() async {
        let mockChatService = MockChatService()
        mockChatService._stubbedChatTestActive = false
        mockChatService.chatOptedIn = false
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatOptInController = expectedViewController
        let navigationController = UINavigationController()
        await confirmation() { confirmation in
            let sut = ChatOffboardingCoordinator(
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



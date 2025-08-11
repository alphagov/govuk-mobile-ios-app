import Foundation
import UIKit
import GOVKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct ChatInfoOnboardingCoordinatorTests {
    @Test
    func start_setsChatInfoOnboardingViewController() throws {
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedChatInfoOnboardingController = expectedViewController
        let navigationController = UINavigationController()
        let sut = ChatInfoOnboardingCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            cancelOnboardingAction: { }
        )

        sut.start()
        let firstViewController = navigationController.viewControllers.first
        #expect(firstViewController == expectedViewController)
    }
}

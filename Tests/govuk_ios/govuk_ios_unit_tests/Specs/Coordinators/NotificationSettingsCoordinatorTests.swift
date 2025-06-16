import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
struct NotificationSettingsCoordinatorTests {

    @Test
    func start_setsNotificationSettingsViewController() {
        let mockNavigationController = MockNavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedNotificationSettingsViewController = expectedViewController
        let coordinator = NotificationSettingsCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            notificationService: MockNotificationService(),
            coordinatorBuilder: MockCoordinatorBuilder.mock,
            completeAction: { },
            dismissAction: { }
        )
        coordinator.start(url: nil)
        #expect(mockNavigationController._pushedViewController == expectedViewController)
    }

    @Test
    func viewPrivacyAction_startsSafari() async {
        let mockNavigationController = MockNavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock

        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        let coordinator = NotificationSettingsCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            notificationService: MockNotificationService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            completeAction: { },
            dismissAction: { }
        )
        coordinator.start(url: nil)

        mockViewControllerBuilder._receivedNotificationSettingsViewPrivacyAction?()

        #expect(mockSafariCoordinator._startCalled)
    }
}

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
            completeAction: { }
        )
        coordinator.start(url: nil)
        #expect(mockNavigationController._pushedViewController == expectedViewController)
    }
}

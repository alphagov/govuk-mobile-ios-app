import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct RecentActivityCoordinatorTests {
    @Test
    func start_setsRecentActivityViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockActivityService = MockActivityService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedRecentActivityViewController = expectedViewController

        let subject = RecentActivityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService
        )

        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }
}

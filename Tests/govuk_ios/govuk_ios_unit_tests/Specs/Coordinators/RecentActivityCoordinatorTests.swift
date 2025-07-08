import Foundation
import UIKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct RecentActivityCoordinatorTests {
    @Test
    func start_setsRecentActivityViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockActivityService = MockActivityService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedRecentActivityViewController = expectedViewController

        let subject = RecentActivityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            coordinatorBuilder: mockCoordinatorBuilder
        )

        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func selectAction_opensSafari() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockActivityService = MockActivityService()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedRecentActivityViewController = expectedViewController

        let subject = RecentActivityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            activityService: mockActivityService,
            coordinatorBuilder: mockCoordinatorBuilder
        )
        
        subject.start()
        let expectedURL = URL.arrange
        mockViewControllerBuilder._receivedRecentActivitySelectedAction?(expectedURL)

        #expect(mockCoordinatorBuilder._receivedSafariCoordinatorURL == expectedURL)
    }
}

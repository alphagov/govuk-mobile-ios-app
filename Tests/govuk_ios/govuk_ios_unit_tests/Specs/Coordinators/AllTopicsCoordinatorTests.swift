import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AllTopicsCoordinatorTests {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_setsAllTopicsController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock

        mockViewControllerBuilder._stubbedAllTopicsViewController = expectedViewController

        let subject = AllTopicsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            coordinatorBuilder: mockCoordinatorBuilder,
            topics: [Topic()]
        )

        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }
}


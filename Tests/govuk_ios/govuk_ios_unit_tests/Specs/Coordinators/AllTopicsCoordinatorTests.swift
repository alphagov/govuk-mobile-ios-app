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
        let mockTopicsService = MockTopicsService()

        mockViewControllerBuilder._stubbedAllTopicsViewController = expectedViewController

        let subject = AllTopicsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            coordinatorBuilder: mockCoordinatorBuilder,
            topicsService: mockTopicsService
        )

        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    @MainActor
    func topicAction_startsCoordinator() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let navigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockTopicsService = MockTopicsService()
        let mockTopicCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedTopicCoordinator = mockTopicCoordinator

        let subject = AllTopicsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            coordinatorBuilder: mockCoordinatorBuilder,
            topicsService: mockTopicsService
        )

        subject.start()

        mockViewControllerBuilder._receivedTopicAction?(Topic())

        #expect(mockTopicCoordinator._startCalled)
    }
}


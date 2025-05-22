import UIKit
import Foundation
import Testing
import SafariServices

@testable import govuk_ios

@Suite
struct TopicDetailsCoordinatorTests {
    @Test
    @MainActor
    func start_pushesTopicDetailspresentsSafariViewController() throws {
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockCoreDataRepository = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: mockCoreDataRepository.viewContext)
        let subject = TopicDetailsCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            activityService: MockActivityService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            topic: topic
        )
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedTopicDetailViewController = expectedViewController
        subject.start()

        #expect(mockNavigationController._pushedViewController == expectedViewController)
    }

    @Test
    @MainActor
    func openAction_startsSafari() throws {
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockCoreDataRepository = CoreDataRepository.arrangeAndLoad
        let topic = Topic.arrange(context: mockCoreDataRepository.viewContext)
        let subject = TopicDetailsCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            activityService: MockActivityService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            topic: topic
        )
        subject.start()
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator
        let url = URL.arrange
        mockViewControllerBuilder._receivedTopicDetailOpenAction?(url)

        #expect(mockCoordinatorBuilder._receivedSafariCoordinatoirURL == url)
        #expect(mockSafariCoordinator._startCalled)
    }

}

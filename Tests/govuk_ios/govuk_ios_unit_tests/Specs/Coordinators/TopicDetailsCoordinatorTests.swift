import UIKit
import Foundation
import Testing
import SafariServices

@testable import GOVKitTestUtilities
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

        #expect(mockCoordinatorBuilder._receivedSafariCoordinatorURL == url)
        #expect(mockSafariCoordinator._startCalled)
    }

    @Test
    @MainActor
    func stepByStepAction_pushesStepBySteps() throws {
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedStepByStepsViewController = UIViewController()
        mockViewControllerBuilder._stubbedStepByStepViewController = expectedStepByStepsViewController
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

        let expectedContent = TopicDetailResponse.Content.arrange
        mockViewControllerBuilder._receivedTopicDetailStepByStepAction?([expectedContent])

        #expect(mockNavigationController._pushedViewController == expectedStepByStepsViewController)
        #expect(mockViewControllerBuilder._receivedStepByStepContent?.first?.url == expectedContent.url)
    }

    @Test
    @MainActor
    func stepByStep_OpenAction_startsSafari() throws {
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedStepByStepsViewController = UIViewController()
        mockViewControllerBuilder._stubbedStepByStepViewController = expectedStepByStepsViewController
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

        let expectedContent = TopicDetailResponse.Content.arrange
        mockViewControllerBuilder._receivedTopicDetailStepByStepAction?([expectedContent])
        mockViewControllerBuilder._receivedStepByStepSelectedAction?(expectedContent)

        #expect(mockSafariCoordinator._startCalled)
    }
}

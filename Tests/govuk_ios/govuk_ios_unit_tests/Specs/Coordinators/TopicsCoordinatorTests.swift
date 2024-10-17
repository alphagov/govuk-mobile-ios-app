import Testing
import UIKit
@testable import govuk_ios

@Suite
struct TopicsCoordinatorTests {

    @MainActor
    @Test
    func start_setsTopicDetailView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let mockTopicsService = MockTopicsService()
        let mockActivityService = MockActivityService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        
        mockViewControllerBuilder._stubbedTopicDetailViewController = expectedViewController
        
        let subject = TopicDetailsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            topicsService: mockTopicsService,
            activityService: mockActivityService,
            viewControllerBuilder: mockViewControllerBuilder,
            topic: Topic()
        )
        
        subject.start()
        
        #expect(navigationController.viewControllers.first == expectedViewController)
    }

}

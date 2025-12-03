import Testing
import UIKit

@testable import govuk_ios

@Suite
struct TopicsDetailCoordinatorTests {
    @MainActor
    @Test
    func start_setsTopicDetailView() throws {
        let coreData = CoreDataRepository.arrangeAndLoad
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
            coordinatorBuilder: MockCoordinatorBuilder.mock,
            viewControllerBuilder: mockViewControllerBuilder,
            topic: Topic(context: coreData.viewContext)
        )
        
        subject.start()
        
        #expect(navigationController.viewControllers.first == expectedViewController)
    }
}

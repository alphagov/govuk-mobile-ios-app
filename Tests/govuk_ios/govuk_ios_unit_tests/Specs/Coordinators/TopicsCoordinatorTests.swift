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
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        
        mockViewControllerBuilder._stubbedTopicDetailViewController = expectedViewController
        
        let subject = TopicsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            topic: Topic()
        )
        
        subject.start()
        
        #expect(navigationController.viewControllers.first == expectedViewController)
    }

}

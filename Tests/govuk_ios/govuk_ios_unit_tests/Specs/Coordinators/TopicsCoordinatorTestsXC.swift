import XCTest

@testable import govuk_ios

@MainActor
final class TopicsCoordinatorTestsXC: XCTestCase {

    func test_start_setsTopicDetailView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()
        
        mockViewControllerBuilder._stubbedTopicDetailViewController = expectedViewController
        
        let subject = TopicsCoordinator(
            navigationController: navigationController,
            analyticsService: mockAnalyticsService,
            viewControllerBuilder: mockViewControllerBuilder,
            topic: Topic(ref: "ref", title: "Title")
        )
        
        subject.start()
        
        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }

}

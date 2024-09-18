import XCTest
@testable import govuk_ios

final class RecentActivityCoordinatortests: XCTestCase {

    @MainActor
    func test_start_setsRecentActivityViewController() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedRecentActivityViewController = expectedViewController

        let subject = RecentActivityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }
}

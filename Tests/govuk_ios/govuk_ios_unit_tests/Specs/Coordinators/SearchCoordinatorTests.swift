import Foundation
import XCTest

@testable import govuk_ios

class SearchCoordinatorTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_setsSearchViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedSearchViewController = expectedViewController

        let subject = SearchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService
        )
        
        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }
}

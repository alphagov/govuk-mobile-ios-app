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
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(),
            dismissed: { }
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }

    @MainActor
    func test_dragToDismiss_callsDismissed() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let navigationController = UINavigationController()

        mockViewControllerBuilder._stubbedSearchViewController = expectedViewController

        let expectation = expectation()
        let subject = SearchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(),
            dismissed: {
                expectation.fulfill()
            }
        )
        subject.start()

        subject.presentationControllerDidDismiss(subject.root.presentationController!)

        wait(for: [expectation], timeout: 0.5)
    }

    @MainActor
    func test_dismissModal_callsDismissed() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAnalyticsService = MockAnalyticsService()
        let expectedViewController = UIViewController()
        let mockNavigationController = MockNavigationController()

        mockViewControllerBuilder._stubbedSearchViewController = expectedViewController

        let expectation = expectation()
        let subject = SearchCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            searchService: MockSearchService(),
            dismissed: {
                expectation.fulfill()
            }
        )
        subject.start()

        //Simulate view controller calling close
        mockViewControllerBuilder._receivedSearchDismissAction?()

        XCTAssertEqual(mockNavigationController._dismissCalled, true)
        XCTAssertEqual(mockNavigationController._receivedDismissAnimated, true)

        wait(for: [expectation], timeout: 0.5)
    }
}

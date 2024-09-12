import Foundation
import XCTest

@testable import govuk_ios

class HomeCoordinatorTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_setsHomeViewController() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder(container: .init())
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedHomeViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService()
        )
        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }
}

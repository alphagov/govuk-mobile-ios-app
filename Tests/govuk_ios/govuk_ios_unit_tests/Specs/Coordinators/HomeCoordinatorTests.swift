import Foundation
import XCTest

@testable import govuk_ios

class HomeCoordinatorTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_showsHomeViewController() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedHomeViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = HomeCoordinator(
            navigationController: navigationController,
            coodinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [])
        )
        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }
}

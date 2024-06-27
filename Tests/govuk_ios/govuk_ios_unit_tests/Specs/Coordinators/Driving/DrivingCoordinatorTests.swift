import Foundation
import XCTest

@testable import govuk_ios

class DrivingCoordinatorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedDrivingViewController = expectedViewController
        
        let subject = DrivingCoordinator(
            navigationController: navigationController, 
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }

    @MainActor
    func test_showPermit_startsPermitCoordinator() {
        let navigationController = UINavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedDrivingViewController = expectedViewController

        let subject = DrivingCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder
        )

        subject.start()

        let expectedPermitCoodinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPermitCoordinator = expectedPermitCoodinator
        mockViewControllerBuilder._receivedShowPermitAction?()

        XCTAssertTrue(expectedPermitCoodinator._startCalled)
    }

}

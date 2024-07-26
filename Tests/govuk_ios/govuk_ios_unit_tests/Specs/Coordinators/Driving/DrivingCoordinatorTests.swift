import Foundation
import XCTest

@testable import govuk_ios

class DrivingCoordinatorTests: XCTestCase {
    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
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
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
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
        mockViewControllerBuilder._receivedDrivingShowPermitAction?()

        XCTAssertTrue(expectedPermitCoodinator._startCalled)
        XCTAssertEqual(mockCoordinatorBuilder._receivedPermitNavigationController, subject.root)
    }

    @MainActor
    func test_presentPermit_startsPermitCoordinator() {
        let navigationController = UINavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
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
        mockViewControllerBuilder._receivedDrivingPresentPermitAction?()

        XCTAssertTrue(expectedPermitCoodinator._startCalled)
        XCTAssertNotNil(mockCoordinatorBuilder._receivedPermitNavigationController)
        XCTAssertNotEqual(mockCoordinatorBuilder._receivedPermitNavigationController, subject.root)
    }

}

import Foundation
import XCTest

@testable import govuk_ios

class RedCoordinatorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_showsRedViewController() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let subject = RedCoordinator(
            navigationController: navigationController,
            coodinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder
        )

        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedRedViewController = expectedViewController
        subject.start()

        XCTAssertEqual(navigationController.viewControllers.first, expectedViewController)
    }

    @MainActor
    func test_showNextAction_startsNextCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let subject = RedCoordinator(
            navigationController: navigationController,
            coodinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder
        )

        subject.start()
        let expectedCoordinator = MockBaseCoordinator()
        mockCoodinatorBuilder._stubbedNextCoordinator = expectedCoordinator

        mockViewControllerBuilder._receivedRedShowNextAction?()

        XCTAssertEqual(mockCoodinatorBuilder._receivedNextTitle, "Next")
        XCTAssertEqual(mockCoodinatorBuilder._receivedNextNavigationController, subject.root)
        XCTAssertTrue(expectedCoordinator._startCalled)
    }

    @MainActor
    func test_showModalAction_startsNextCoordinator() {
        let mockCoodinatorBuilder = MockCoordinatorBuilder()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let subject = RedCoordinator(
            navigationController: navigationController,
            coodinatorBuilder: mockCoodinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder
        )

        subject.start()
        let expectedCoordinator = MockBaseCoordinator()
        mockCoodinatorBuilder._stubbedNextCoordinator = expectedCoordinator

        mockViewControllerBuilder._receivedRedShowModalAction?()

        XCTAssertEqual(mockCoodinatorBuilder._receivedNextTitle, "Modal")
        XCTAssertNotEqual(mockCoodinatorBuilder._receivedNextNavigationController, subject.root)
        XCTAssertTrue(expectedCoordinator._startCalled)
    }

}

import Foundation
import XCTest

@testable import govuk_ios

class BlueCoordinatorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock,
            viewControllerBuilder: .mock,
            deeplinkStore: .init(routes: []),
            requestFocus: { _ in }
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    @MainActor
    func test_startDriving_startsDrivingCoordinator() {
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockDrivingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedDrivingCoordinator = mockDrivingCoordinator
        let mockViewControllerBuilder = ViewControllerBuilder.mock
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: .init(routes: []),
            requestFocus: { _ in }
        )

        subject.start()

        mockViewControllerBuilder._receivedBlueShowNextAction?()

        XCTAssertTrue(mockDrivingCoordinator._startCalled)
    }

    @MainActor
    func test_start_withMatchingURL_showsViewController() {
        let navigationController = UINavigationController()
        let mockRoute = MockDeeplinkRoute(pattern: "/test")
        let mockDeeplinkDataStore = DeeplinkDataStore(routes: [
            mockRoute
        ])

        let focusExpectation = expectation(description: "focus expectation")
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock,
            viewControllerBuilder: .mock,
            deeplinkStore: mockDeeplinkDataStore,
            requestFocus: { _ in
                focusExpectation.fulfill()
            }
        )

        let url = URL(string: "govuk://gov.uk/test")
        subject.start(url: url)
        wait(for: [focusExpectation])

        XCTAssertEqual(navigationController.viewControllers.count, 1)

        let actionExpectation = expectation(description: "action expectation")
        actionExpectation.fulfillAfter(0.2)
        waitForExpectations(
            timeout: 0.5,
            handler: { _ in
                XCTAssert(mockRoute._actionCalled)
            }
        )
    }

}

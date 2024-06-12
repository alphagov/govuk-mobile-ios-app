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
            requestFocus: { nav in

            }
        )

        subject.start(url: nil)

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    @MainActor
    func test_start_withDeeplink_requestsFocus() {
        let navigationController = UINavigationController()
        let expectation = expectation(description: "focus handler")
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock,
            requestFocus: { nav in
                XCTAssertEqual(nav, navigationController)
                expectation.fulfill()
            }
        )

        subject.start(url: "/driving")

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        wait(for: [expectation], timeout: 1)
    }

}

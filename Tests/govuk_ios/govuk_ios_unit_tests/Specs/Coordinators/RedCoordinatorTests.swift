import Foundation
import XCTest

@testable import govuk_ios

class RedCoordinatorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let subject = RedCoordinator(
            navigationController: navigationController
        )

        subject.start(url: nil)

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

}

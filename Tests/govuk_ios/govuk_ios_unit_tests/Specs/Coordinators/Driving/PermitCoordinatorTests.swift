import Foundation
import XCTest

@testable import govuk_ios

class PermitCoordinatorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let subject = PermitCoordinator(
            navigationController: navigationController
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

}

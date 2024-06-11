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
        let subject = DrivingCoordinator(
            navigationController: navigationController
        )

        subject.start(url: nil)

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

}

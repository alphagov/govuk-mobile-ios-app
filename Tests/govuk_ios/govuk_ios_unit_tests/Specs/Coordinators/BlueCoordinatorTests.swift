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
            deeplinkStore: .init(routes: []),
            requestFocus: { _ in }
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

}

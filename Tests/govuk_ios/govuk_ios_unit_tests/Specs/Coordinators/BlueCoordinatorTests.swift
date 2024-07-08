import Foundation
import XCTest

@testable import govuk_ios

class BlueCoordinatorTests: XCTestCase {
    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

}

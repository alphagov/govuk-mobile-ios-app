import Foundation
import XCTest

@testable import govuk_ios

class NextCoordinatorTests: XCTestCase {

    @MainActor
    func test_start_pushesViewController() {
        let mockNavigationController = MockNavigationController()
        let subject = NextCoordinator(
            title: "Test",
            navigationController: mockNavigationController
        )

        subject.start()

        XCTAssertNotNil(mockNavigationController._pushedViewController)
        XCTAssert(mockNavigationController._pushedViewController is TestViewController?)
    }

}

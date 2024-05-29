import Foundation
import XCTest

import Coordination

@testable import govuk_ios

class LaunchCoordinatorTests: XCTestCase {

    @MainActor
    func test_start_callsCompletion() {
        let mockNavigationController = UINavigationController()

        let expectation = expectation(description: "completion expectation")
        let subject = LaunchCoordinator(
            navigationController: mockNavigationController,
            completion: {
                expectation.fulfill()
            }
        )

        subject.start()
        wait(for: [expectation], timeout: 2)
    }

}

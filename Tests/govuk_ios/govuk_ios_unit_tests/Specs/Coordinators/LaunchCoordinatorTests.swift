import Foundation
import XCTest

@testable import govuk_ios

class LaunchCoordinatorTests: XCTestCase {

    override func setUp() {
        UIView.setAnimationsEnabled(false)
    }

    @MainActor
    func test_start_launchCompletion_callsCompletion() {
        let mockNavigationController = UINavigationController()

        let expectation = expectation(description: #function)
        let subject = LaunchCoordinator(
            navigationController: mockNavigationController,
            completion: {
                expectation.fulfill()
            }
        )

        subject.start()
        let viewController = mockNavigationController.viewControllers.first
        viewController?.viewDidAppear(true)
        wait(for: [expectation], timeout: 10)
    }

}

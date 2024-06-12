import Foundation
import XCTest

@testable import govuk_ios

class LaunchCoordinatorTests: XCTestCase {

    @MainActor
    func test_start_callsCompletion() {
        let mockNavigationController = UINavigationController()

        let expectation = expectation(description: #function)
        let mockDeeplinkService = MockDeeplinkService()
        let subject = LaunchCoordinator(
            navigationController: mockNavigationController,
            deeplinkService: mockDeeplinkService,
            completion: { _ in
                expectation.fulfill()
            }
        )

        subject.start(url: nil)
        wait(for: [expectation], timeout: 2)
    }
}

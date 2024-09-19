import Foundation
import XCTest

@testable import govuk_ios

class LaunchCoordinatorTests: XCTestCase {
    @MainActor
    func test_start_launchCompletion_callsCompletion() {
        let mockNavigationController = UINavigationController()
        let mockViewControllerBuilder = ViewControllerBuilder.mock
        let expectation = expectation()
        let subject = LaunchCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            appConfigService: MockAppConfigService(),
            completion: {
                expectation.fulfill()
            }
        )
        subject.start()
        mockViewControllerBuilder._receivedLaunchCompletion?()
        wait(for: [expectation])
    }

}

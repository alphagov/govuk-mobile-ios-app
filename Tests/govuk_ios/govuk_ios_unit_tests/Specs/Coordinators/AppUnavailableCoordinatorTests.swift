import XCTest

@testable import govuk_ios

final class AppUnavailableCoordinatorTests: XCTestCase {
    func test_start_isAppAvailable_trueCallsDismiss() throws {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppAvailable = true
        let expectation = expectation()
        let sut = AppUnavailableCoordinator(
            navigationController: UINavigationController(),
            appConfigService: mockAppConfigService,
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_isAppAvailable_falseDoesntCallDismiss() throws {
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.isAppAvailable = false
        let expectation = expectation()
        expectation.isInverted = true
        let sut = AppUnavailableCoordinator(
            navigationController: UINavigationController(),
            appConfigService: mockAppConfigService,
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }
}

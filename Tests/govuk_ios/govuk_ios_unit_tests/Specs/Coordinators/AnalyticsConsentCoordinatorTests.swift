import XCTest

@testable import govuk_ios

final class AnalyticsConsentCoordinatorTests: XCTestCase {
    func test_start_analyticsPermissionState_acceptedCallsDismiss() throws {
        let analyticsService = MockAnalyticsService()
        analyticsService._stubbedPermissionState = .accepted
        let mockNavigationController = UINavigationController()
        let expectation = expectation()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            analyticsService: analyticsService,
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_analyticsPermissionState_deniedCallsDismiss() throws {
        let analyticsService = MockAnalyticsService()
        analyticsService._stubbedPermissionState = .denied
        let mockNavigationController = UINavigationController()
        let expectation = expectation()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            analyticsService: analyticsService,
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_analyticsPermissionState_unknownDoesntCallDismiss() throws {
        let analyticsService = MockAnalyticsService()
        analyticsService._stubbedPermissionState = .unknown
        let navigationController = UINavigationController()
        let sut = AnalyticsConsentCoordinator(
            navigationController: navigationController,
            analyticsService: analyticsService,
            dismissAction: { }
        )
        sut.start()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
}

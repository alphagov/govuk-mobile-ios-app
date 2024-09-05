import XCTest

@testable import govuk_ios

final class AnalyticsConsentCoordinatorTests: XCTestCase {
    func test_start_hasSeenAnalyticsConsent_callsDismiss() throws {
        let analyticsConsentService = MockAnalyticsConsentService()
        analyticsConsentService._stubbedHasSeenAnalyticsConsent = true
        let mockNavigationController = UINavigationController()
        let expectation = expectation()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            analyticsConsentService: analyticsConsentService,
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_hasNotSeenAnalyticsConsent_doesNotCallDismiss() throws {
        let analyticsConsentService = MockAnalyticsConsentService()
        analyticsConsentService._stubbedHasSeenAnalyticsConsent = false
        let mockNavigationController = UINavigationController()
        let sut = AnalyticsConsentCoordinator(
            navigationController: mockNavigationController,
            analyticsConsentService: analyticsConsentService,
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                XCTFail()
            }
        )
        sut.start()
    }
}

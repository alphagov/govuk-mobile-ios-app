import Foundation
import XCTest

@testable import govuk_ios

final class AnalyticsConsentContainerViewModelTests: XCTestCase {
    func test_init_hasCorrectInitialState() throws {
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            dismissAction: {}
        )
        XCTAssertEqual(sut.title, "Share statistics about how you use the GOV.UK app")
        XCTAssertEqual(sut.descriptionTop, "You can help us improve this app by agreeing to share statistics about:")
        XCTAssertEqual(
            sut.descriptionBullets,
        """
          •  the pages you visit within the app
          •  how long you spend on each page
          •  what you tap on while you're on each page
          •  errors that happen
        """
        )
        XCTAssertEqual(sut.descriptionBottom, "These statistics are anonymous.\n\nYou can stop sharing these statistics at any time by changing your app settings.")
        XCTAssertEqual(sut.privacyPolicyLinkTitle, "Read more about this in the privacy policy ↗")
        XCTAssertEqual(sut.privacyPolicyLinkAccessibilityTitle, "Read more about this in the privacy policy")
        XCTAssertEqual(sut.privacyPolicyLinkHint, "Opens in web browser")
        XCTAssertEqual(sut.privacyPolicyLinkUrl, "https://www.gov.uk/government/publications/govuk-app-privacy-notice-how-we-use-your-data")
        XCTAssertEqual(sut.allowButtonTitle, "Allow statistics sharing")
        XCTAssertEqual(sut.dontAllowButtonTitle, "Don't allow statistics sharing")
    }

    func test_allowButtonAction_setsAcceptedAnalyticsToTrue() throws {
        let analyticsService = MockAnalyticsService()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            dismissAction: {}
        )
        sut.allowButtonViewModel.action()
        XCTAssertEqual(analyticsService._setAcceptedAnalyticsAccepted, true)
    }

    func test_allowButtonAction_callsDismiss() throws {
        let expectation = expectation()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            dismissAction: { expectation.fulfill() }
        )
        sut.dontAllowButtonViewModel.action()
        wait(for: [expectation], timeout: 1)
    }

    func test_dontAllowButtonAction_setsAcceptedAnalyticsToFalse() throws {
        let analyticsService = MockAnalyticsService()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            dismissAction: {}
        )
        sut.dontAllowButtonViewModel.action()
        XCTAssertEqual(analyticsService._setAcceptedAnalyticsAccepted, false)
    }

    func test_dontAllowButtonAction_callsDismiss() throws {
        let expectation = expectation()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            dismissAction: { expectation.fulfill() }
        )
        sut.dontAllowButtonViewModel.action()
        wait(for: [expectation], timeout: 1)
    }

    func test_openPrivacyPolicy_opensURL() throws {
        let urlOpener = MockURLOpener()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            urlOpener: urlOpener,
            dismissAction: {}
        )
        sut.openPrivacyPolicy()
        XCTAssertEqual(urlOpener._receivedOpenIfPossibleUrlString, Constants.API.privacyPolicyUrl)
    }
}

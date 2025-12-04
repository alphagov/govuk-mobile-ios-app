import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AnalyticsConsentContainerViewModelTests {
    @Test
    func init_hasCorrectInitialState() {
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            completion: {},
            viewPrivacyAction: {}
        )
        #expect(sut.title == "Help improve the app by sharing statistics")
        #expect(sut.descriptionTop == "You can help us improve this app by agreeing to share statistics about:")
        #expect(
            sut.descriptionBullets ==
            ["the pages you visit within the app",
             "how long you spend on each page",
             "what you tap on while you're on each page",
             "errors that happen"]
        )
        #expect(sut.descriptionBottom == "We will not use these statistics to directly identify you.\n\nYou can stop sharing these statistics at any time by changing your app settings.")
        #expect(sut.privacyPolicyLinkTitle == "Read more about this in the privacy notice ↗")
        #expect(sut.privacyPolicyLinkAccessibilityTitle == "Read more about this in the privacy notice")
        #expect(sut.privacyPolicyLinkHint == "Opens in web browser")
        #expect(sut.privacyPolicyLinkUrl.absoluteString == "https://www.gov.uk/government/publications/govuk-app-privacy-notice-how-we-use-your-data")
        #expect(sut.allowButtonTitle == "Share statistics")
        #expect(sut.dontAllowButtonTitle == "Not now")
    }

    @Test
    func allowButtonAction_setsAcceptedAnalyticsToTrue() {
        let analyticsService = MockAnalyticsService()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            completion: {},
            viewPrivacyAction: {}
        )
        sut.allowButtonViewModel.action()
        #expect(analyticsService._setAcceptedAnalyticsAccepted == true)
    }

    @Test
    func allowButtonAction_callsDismiss() async {
        let dismissCalled = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentContainerViewModel(
                analyticsService: nil,
                completion: {
                    continuation.resume(returning: true)
                },
                viewPrivacyAction: {}
            )
            sut.dontAllowButtonViewModel.action()
        }
        #expect(dismissCalled)
    }

    @Test
    func dontAllowButtonAction_setsAcceptedAnalyticsToFalse() {
        let analyticsService = MockAnalyticsService()
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: analyticsService,
            completion: {},
            viewPrivacyAction: {}
        )
        sut.dontAllowButtonViewModel.action()
        #expect(analyticsService._setAcceptedAnalyticsAccepted == false)
    }

    @Test
    func dontAllowButtonAction_callsDismiss() async {
        let dismissCalled = await withCheckedContinuation { continuation in
            let sut = AnalyticsConsentContainerViewModel(
                analyticsService: nil,
                completion: {
                    continuation.resume(returning: true)
                },
                viewPrivacyAction: {}
            )
            sut.dontAllowButtonViewModel.action()
        }
        #expect(dismissCalled)
    }

    @Test
    func openPrivacyPolicy_opensURL() {
        var viewPrivacyActionCalled = false
        let sut = AnalyticsConsentContainerViewModel(
            analyticsService: nil,
            completion: {},
            viewPrivacyAction: {
                viewPrivacyActionCalled = true
            }
        )
        sut.openPrivacyPolicy()
        #expect(viewPrivacyActionCalled == true)
    }
}

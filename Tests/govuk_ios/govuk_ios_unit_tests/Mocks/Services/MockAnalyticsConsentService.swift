import Foundation

@testable import govuk_ios

class MockAnalyticsConsentService: AnalyticsConsentServiceInterface {

    var _stubbedHasSeenAnalyticsConsent: Bool = false
    var hasSeenAnalyticsConsent: Bool {
        _stubbedHasSeenAnalyticsConsent
    }

    var _setHasSeenAnalyticsConsent: Bool = false
    func setHasSeenAnalyticsConsent() {
        _setHasSeenAnalyticsConsent = true
    }
}

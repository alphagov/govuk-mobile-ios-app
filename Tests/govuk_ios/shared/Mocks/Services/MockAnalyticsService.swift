import XCTest
import GOVKit

@testable import govuk_ios

class MockAnalyticsService: AnalyticsServiceInterface {
    var _launchCalled: Bool = false
    func launch() {
        _launchCalled = true
    }

    var _trackedEvents: [AppEvent] = []
    func track(event: AppEvent) {
        _trackedEvents.append(event)
    }

    var _trackScreenReceivedScreens: [TrackableScreen] = []
    func track(screen: TrackableScreen) {
        _trackScreenReceivedScreens.append(screen)
    }

    var _trackSetUserPropertyReceivedProperty: UserProperty?
    func set(userProperty: UserProperty) {
        _trackSetUserPropertyReceivedProperty = userProperty
    }

    var _resetConsentCalled: Bool = false
    func resetConsent() {
        _resetConsentCalled = true
    }

    var _setAcceptedAnalyticsAccepted: Bool = true
    func setAcceptedAnalytics(accepted: Bool) {
        _setAcceptedAnalyticsAccepted = accepted
        _stubbedPermissionState = accepted ? .accepted : .denied
    }

    var _stubbedPermissionState: AnalyticsPermissionState = .accepted
    var permissionState: AnalyticsPermissionState {
        _stubbedPermissionState
    }
}

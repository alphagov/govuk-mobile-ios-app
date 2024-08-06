import XCTest
import Logging

@testable import govuk_ios

class MockAnalyticsService: AnalyticsServiceInterface {

    var _configureCalled: Bool = false
    func configure() {
        _configureCalled = true
    }

    var _trackedEvents: [AppEvent] = []
    func track(event: AppEvent) {
        _trackedEvents.append(event)
    }

    var _trackScreensVisited: [Logging.LoggableScreenV2] = []
    func trackScreen(_ screen: any Logging.LoggableScreenV2) {
        _trackScreensVisited.append(screen)
    }

    var _setAcceptedAnalyticsAccepted: Bool = true
    func setAcceptedAnalytics(accepted: Bool) {
        _setAcceptedAnalyticsAccepted = accepted
    }

    var _stubbedPermissionState: AnalyticsPermissionState = .accepted
    var permissionState: AnalyticsPermissionState {
        _stubbedPermissionState
    }
}

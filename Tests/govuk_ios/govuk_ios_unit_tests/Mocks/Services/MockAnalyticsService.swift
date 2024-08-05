import XCTest
import Logging

@testable import govuk_ios

class MockAnalyticsService: AnalyticsServiceInterface {
    private(set) var screensVisited = [Logging.LoggableScreenV2]()
    private(set) var eventsLogged = [govuk_ios.AppEvent]()

    func configure() {}

    func track(event: govuk_ios.AppEvent) {
        eventsLogged.append(event)
    }

    func trackScreen(_ screen: any Logging.LoggableScreenV2) {
        screensVisited.append(screen)
    }

    var _stubbedAcceptedAnalytics: Bool = true
    func setAcceptedAnalytics(accepted: Bool) {
        _stubbedAcceptedAnalytics = accepted
    }

    var _stubbedPermissionState: AnalyticsPermissionState = .accepted
    var permissionState: AnalyticsPermissionState {
        _stubbedPermissionState
    }
}

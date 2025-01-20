import Foundation
import GOVKit

@testable import govuk_ios

class MockAnalyticsClient: AnalyticsClient {
    var _launchCalled: Bool = false
    func launch() {
        _launchCalled = true
    }

    var _enabledReceived: Bool?
    func setEnabled(enabled: Bool) {
        _enabledReceived = enabled
    }

    var _trackScreenReceivedScreens: [TrackableScreen] = []
    func track(screen: any TrackableScreen) {
        _trackScreenReceivedScreens.append(screen)
    }

    var _trackEventReceivedEvents: [AppEvent] = []
    func track(event: AppEvent) {
        _trackEventReceivedEvents.append(event)
    }

    var _trackSetUserPropertyReceivedProperty: UserProperty?
    func set(userProperty: UserProperty) {
        _trackSetUserPropertyReceivedProperty = userProperty
    }
}

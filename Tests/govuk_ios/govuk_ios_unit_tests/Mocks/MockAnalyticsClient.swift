import Foundation

@testable import govuk_ios

class MockAnalyticsClient: AnalyticsClient {

    var _launchCalled: Bool = false
    func launch() {
        _launchCalled = true
    }

    func setEnabled(enabled: Bool) {

    }

    var _trackScreenReceivedScreens: [TrackableScreen] = []
    func track(screen: any TrackableScreen) {
        _trackScreenReceivedScreens.append(screen)
    }

    var _trackEventReceivedEvents: [AppEvent] = []
    func track(event: AppEvent) {
        _trackEventReceivedEvents.append(event)
    }
}

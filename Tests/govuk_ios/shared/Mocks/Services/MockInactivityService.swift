import Foundation

@testable import govuk_ios

class MockInactivityService: InactivityServiceInterface {
    var startMonitoringHandler: (() -> Void)?

    var _stubbedInactive: Bool = false
    var inactive: Bool {
        return _stubbedInactive
    }

    var _stubbedstartMonitoringCalled = false
    func startMonitoring(inactivityHandler: @escaping () -> Void) {
        _stubbedstartMonitoringCalled = true
        startMonitoringHandler = inactivityHandler
    }

    var _resetTimerCalled = false
    func resetTimer() {
        _resetTimerCalled = true
    }

    func simulateInactivity() {
        _stubbedInactive = true
        startMonitoringHandler?()
    }

    func simulateActivity() {
        _stubbedInactive = false
    }
}

import Foundation

@testable import govuk_ios

class MockInactivityService: InactivityServiceInterface {

    var _stubbedInactive: Bool = false
    var inactive: Bool {
        return _stubbedInactive
    }

    var _stubbedStartMonitoringHandler: (() -> Void)?
    var _stubbedStartMonitoringCalled = false
    func startMonitoring(inactivityHandler: @escaping () -> Void) {
        _stubbedStartMonitoringCalled = true
        _stubbedStartMonitoringHandler = inactivityHandler
    }

    var _resetTimerCalled = false
    func resetTimer() {
        _resetTimerCalled = true
    }

    func simulateInactivity() {
        _stubbedInactive = true
        _stubbedStartMonitoringHandler?()
    }

    func simulateActivity() {
        _stubbedInactive = false
    }
}

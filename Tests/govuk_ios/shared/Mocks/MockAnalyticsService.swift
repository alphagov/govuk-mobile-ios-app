import XCTest
import Onboarding

@testable import govuk_ios

class MockAnalyticsService: AnalyticsServiceInterface,
                            OnboardingAnalyticsService {

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

    var _setAcceptedAnalyticsAccepted: Bool = true
    func setAcceptedAnalytics(accepted: Bool) {
        _setAcceptedAnalyticsAccepted = accepted
    }

    var _stubbedPermissionState: AnalyticsPermissionState = .accepted
    var permissionState: AnalyticsPermissionState {
        _stubbedPermissionState
    }

    var _trackOnboardingEventEvent: OnboardingEvent?
    func trackOnboardingEvent(_ event: OnboardingEvent) {
        _trackOnboardingEventEvent = event
    }

    var _trackOnboardingScreenScreen: OnboardingScreen?
    func trackOnboardingScreen(_ screen: OnboardingScreen) {
        _trackOnboardingScreenScreen = screen
    }
}

import Foundation

import Firebase

struct FirebaseClient: AnalyticsClient {
    func launch() {
        FirebaseApp.configure()
    }

    func setEnabled(enabled: Bool) {
        Analytics.setAnalyticsCollectionEnabled(enabled)
    }

    func track(event: AppEvent) {
        Analytics.logEvent(
            event.name,
            parameters: event.params ?? [:]
        )
    }

    func track(screen: any TrackableScreen) {
        let params: [String: Any] = [
            AnalyticsParameterScreenName: screen.trackingName,
            AnalyticsParameterScreenClass: screen.trackingClass,
            "screen_title": screen.trackingTitle,
            "language": screen.trackingLanguage
        ].compactMapValues({ $0 })
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: params
        )
    }
}

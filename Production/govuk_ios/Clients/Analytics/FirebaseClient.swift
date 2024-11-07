import Foundation

import Firebase

struct FirebaseClient: AnalyticsClient {
    private let firebaseApp: FirebaseAppInterface.Type
    private let firebaseAnalytics: FirebaseAnalyticsInterface.Type

    init(firebaseApp: FirebaseAppInterface.Type,
         firebaseAnalytics: FirebaseAnalyticsInterface.Type) {
        self.firebaseApp = firebaseApp
        self.firebaseAnalytics = firebaseAnalytics
    }

    func launch() {
        firebaseApp.configure()
    }

    func setEnabled(enabled: Bool) {
        firebaseAnalytics.setAnalyticsCollectionEnabled(enabled)
    }

    func track(event: AppEvent) {
        firebaseAnalytics.logEvent(
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
        ]
        .merging(
            screen.additionalParameters,
            uniquingKeysWith: { param, _ in param }
        )
        .compactMapValues({ $0 })
        firebaseAnalytics.logEvent(
            AnalyticsEventScreenView,
            parameters: params
        )
    }
}

protocol FirebaseAppInterface {
    static func configure()
}

protocol FirebaseAnalyticsInterface {
    static func setAnalyticsCollectionEnabled(_ newValue: Bool)
    static func logEvent(_ eventName: String, parameters: [String: Any]?)
}

extension FirebaseApp: FirebaseAppInterface {}
extension Analytics: FirebaseAnalyticsInterface {}

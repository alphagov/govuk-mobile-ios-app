import Foundation

import FirebaseCore
import Firebase
import GOVKit

struct FirebaseClient: AnalyticsClient {
    private let firebaseApp: FirebaseAppInterface.Type
    private let firebaseAnalytics: FirebaseAnalyticsInterface.Type
    private let appAttestService: AppAttestServiceInterface

    init(firebaseApp: FirebaseAppInterface.Type,
         firebaseAnalytics: FirebaseAnalyticsInterface.Type,
         appAttestService: AppAttestServiceInterface) {
        self.firebaseApp = firebaseApp
        self.firebaseAnalytics = firebaseAnalytics
        self.appAttestService = appAttestService
    }

    func launch() {
        appAttestService.configure()
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
            .compactMapValues({ $0 })
            .merging(
                screen.additionalParameters,
                uniquingKeysWith: { param, _ in param }
            )
        firebaseAnalytics.logEvent(
            AnalyticsEventScreenView,
            parameters: params
        )
    }

    func set(userProperty: UserProperty) {
        firebaseAnalytics.setUserProperty(
            userProperty.value,
            forName: userProperty.key
        )
    }

    func track(error: Error) { /* Do Nothing */ }
}

protocol FirebaseAppInterface {
    static func configure()
}

protocol FirebaseAnalyticsInterface {
    static func setAnalyticsCollectionEnabled(_ newValue: Bool)
    static func logEvent(_ eventName: String, parameters: [String: Any]?)
    static func setUserProperty(_ value: String?, forName name: String)
}

extension FirebaseApp: FirebaseAppInterface {}
extension Analytics: FirebaseAnalyticsInterface {}

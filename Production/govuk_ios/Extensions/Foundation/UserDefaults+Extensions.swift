import Foundation

extension UserDefaults: UserDefaultsInterface {
    func value(forKey key: UserDefaultsKeys) -> Any? {
        value(forKey: key.rawValue)
    }

    func bool(forKey key: UserDefaultsKeys) -> Bool {
        bool(forKey: key.rawValue)
    }

    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys) {
        set(
            boolValue,
            forKey: key.rawValue
        )
        synchronize()
    }

    func setNotificationsOnboardingSeen() {
        set(bool: true, forKey: .notificationsOnboardingSeen)
        synchronize()
    }

    func isNotificationsOnboardingSeen() -> Bool {
        bool(forKey: .notificationsOnboardingSeen)
    }
}

enum UserDefaultsKeys: String {
    case appOnboardingSeen = "govuk_app_onboarding_seen"
    case acceptedAnalytics = "govuk_app_analytics_accepted"
    case customisedTopics = "govuk_topics_customised"
    case topicsOnboardingSeen = "govuk_topics_onboarding_seen"
    case notificationsOnboardingSeen = "govuk_notifications_onboarding_seen"
    case authenticationOnboardingSeen = "govuk_authentication_onboarding_seen"
    case localAuthenticationOnboardingSeen = "govuk_local_authentication_onboarding_seen"
    case authenticationOnboardingFlowSeen = "govuk_authentication_onboarding_flow_seen"
    case skipLocalAuthentication = "govuk_skip_local_authentication"
    case notificationsConsentGranted = "govuk_notifications_consent_granted"
}

protocol UserDefaultsInterface {
    func value(forKey key: UserDefaultsKeys) -> Any?
    func bool(forKey key: UserDefaultsKeys) -> Bool
    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys)
    func setNotificationsOnboardingSeen()
    func isNotificationsOnboardingSeen() -> Bool
}

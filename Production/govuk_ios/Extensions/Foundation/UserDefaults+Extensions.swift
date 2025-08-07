import Foundation

extension UserDefaults: UserDefaultsInterface {
    func value(forKey key: UserDefaultsKeys) -> Any? {
        value(forKey: key.rawValue)
    }

    func set(_ value: Any?, forKey key: UserDefaultsKeys) {
        set(
            value,
            forKey: key.rawValue
        )
        synchronize()
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

    func removeObject(forKey key: UserDefaultsKeys) {
        removeObject(forKey: key.rawValue)
        synchronize()
    }
}

enum UserDefaultsKeys: String {
    case acceptedAnalytics = "govuk_app_analytics_accepted"
    case customisedTopics = "govuk_topics_customised"
    case topicsOnboardingSeen = "govuk_topics_onboarding_seen"
    case notificationsOnboardingSeen = "govuk_notifications_onboarding_seen"
    case localAuthenticationOnboardingSeen = "govuk_local_authentication_onboarding_seen"
    case notificationsConsentGranted = "govuk_notifications_consent_granted"
    case biometricsPolicyState = "govuk_biometrics_policy_state"
    case touchIdEnabled = "govuk_touch_id_enabled"
    case faceIdSkipped = "govuk_face_id_skipped"
    case refreshTokenExpiryDate = "govuk_refresh_token_expiry_date"
}

protocol UserDefaultsInterface {
    func value(forKey key: UserDefaultsKeys) -> Any?
    func set(_ value: Any?, forKey key: UserDefaultsKeys)
    func bool(forKey key: UserDefaultsKeys) -> Bool
    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys)
    func removeObject(forKey key: UserDefaultsKeys)
}

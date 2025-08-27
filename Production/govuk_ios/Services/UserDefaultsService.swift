import Foundation

protocol UserDefaultsServiceInterface {
    func value(forKey key: UserDefaultsKeys) -> Any?
    func set(_ value: Any?, forKey key: UserDefaultsKeys)
    func bool(forKey key: UserDefaultsKeys) -> Bool
    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys)
    func removeObject(forKey key: UserDefaultsKeys)
}

struct UserDefaultsService: UserDefaultsServiceInterface {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func value(forKey key: UserDefaultsKeys) -> Any? {
        userDefaults.value(forKey: key.rawValue)
    }

    func set(_ value: Any?, forKey key: UserDefaultsKeys) {
        userDefaults.set(
            value,
            forKey: key.rawValue
        )
        userDefaults.synchronize()
    }

    func bool(forKey key: UserDefaultsKeys) -> Bool {
        userDefaults.bool(forKey: key.rawValue)
    }

    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys) {
        userDefaults.set(
            boolValue,
            forKey: key.rawValue
        )
        userDefaults.synchronize()
    }

    func removeObject(forKey key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
        userDefaults.synchronize()
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
    case chatOnboardingSeen = "govuk_chat_onboarding_seen"
    case chatOptedIn = "govuk_chat_opted_in"
}

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
}

enum UserDefaultsKeys: String {
    case appOnboardingSeen = "govuk_app_onboarding_seen"
    case acceptedAnalytics = "govuk_app_analytics_accepted"
    case customisedTopics = "govuk_topics_customised"
    case topicsOnboardingSeen = "govuk_topics_onboarding_seen"
    case redirectedToNotificationsOnboarding = "govuk_redirected_to_notifications_onboarding"
}

protocol UserDefaultsInterface {
    func value(forKey key: UserDefaultsKeys) -> Any?
    func bool(forKey key: UserDefaultsKeys) -> Bool
    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys)
}

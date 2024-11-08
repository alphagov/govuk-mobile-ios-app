import Foundation

extension UserDefaults {
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
    case personalisedTopics = "govuk_topics_personalised"
    case topicsOnboardingSeen = "govuk_topics_onboarding_seen"
}

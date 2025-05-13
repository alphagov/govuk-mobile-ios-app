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

    func deleteAll() {
        for key in UserDefaultsKeys.allCases {
            removeObject(forKey: key.rawValue)
        }
        synchronize()
    }
}

enum UserDefaultsKeys: String, CaseIterable {
    case appOnboardingSeen = "govuk_app_onboarding_seen"
    case acceptedAnalytics = "govuk_app_analytics_accepted"
    case customisedTopics = "govuk_topics_customised"
    case topicsOnboardingSeen = "govuk_topics_onboarding_seen"
    case authenticationOnboardingFlowSeen = "govuk_authentication_onboarding_flow_seen"
    case localAuthenticationEnabled = "govuk_skip_local_authentication_enabled"
}

protocol UserDefaultsInterface {
    func value(forKey key: UserDefaultsKeys) -> Any?
    func bool(forKey key: UserDefaultsKeys) -> Bool
    func set(bool boolValue: Bool,
             forKey key: UserDefaultsKeys)
    func deleteAll()
}

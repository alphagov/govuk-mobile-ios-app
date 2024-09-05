import Foundation

extension UserDefaults {
    func bool(forKey key: UserDefaultsKeys) -> Bool {
        bool(forKey: key.rawValue)
    }

    func set(bool boolValue: Bool,
             forkey key: UserDefaultsKeys) {
        set(
            boolValue,
            forKey: key.rawValue
        )
    }
}

enum UserDefaultsKeys: String {
  case appOnboardingSeen = "govuk_app_onboarding_seen"
  case appAnalyticsConsentSeen = "govuk_app_analytics_consent_seen"
}

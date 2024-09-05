import Foundation

protocol AnalyticsConsentServiceInterface {
    var hasSeenAnalyticsConsent: Bool { get }

    func setHasSeenAnalyticsConsent()
}

struct AnalyticsConsentService: AnalyticsConsentServiceInterface {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var hasSeenAnalyticsConsent: Bool {
        userDefaults.bool(forKey: .appAnalyticsConsentSeen)
    }

    func setHasSeenAnalyticsConsent() {
        userDefaults.set(
            bool: true,
            forkey: .appAnalyticsConsentSeen
        )
    }
}

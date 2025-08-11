import Foundation

protocol NotificationsOnboardingServiceInterface {
    var hasSeenNotificationsOnboarding: Bool { get }

    func setHasSeenNotificationsOnboarding()
}

struct NotificationsOnboardingService: NotificationsOnboardingServiceInterface {
    private let userDefaults: UserDefaultsServiceInterface

    init(userDefaults: UserDefaultsServiceInterface) {
        self.userDefaults = userDefaults
    }

    var hasSeenNotificationsOnboarding: Bool {
        userDefaults.bool(forKey: .notificationsOnboardingSeen)
    }

    func setHasSeenNotificationsOnboarding() {
        userDefaults.set(
            bool: true,
            forKey: .notificationsOnboardingSeen
        )
    }
}

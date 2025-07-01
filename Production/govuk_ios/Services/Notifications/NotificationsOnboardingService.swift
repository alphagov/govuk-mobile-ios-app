import Foundation

protocol NotificationsOnboardingServiceInterface {
    var hasSeenNotificationsOnboarding: Bool { get }

    func setHasSeenNotificationsOnboarding()
}

struct NotificationsOnboardingService: NotificationsOnboardingServiceInterface {
    private let userDefaults: UserDefaultsInterface

    init(userDefaults: UserDefaultsInterface) {
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

import Foundation

protocol NotificationsOnboardingServiceInterface {
    var hasSeenNotificationsOnboarding: Bool { get }

    func setHasSeenNotificationsOnboarding()
}

struct NotificationsOnboardingService: NotificationsOnboardingServiceInterface {
    private let userDefaultsService: UserDefaultsServiceInterface

    init(userDefaultsService: UserDefaultsServiceInterface) {
        self.userDefaultsService = userDefaultsService
    }

    var hasSeenNotificationsOnboarding: Bool {
        userDefaultsService.bool(forKey: .notificationsOnboardingSeen)
    }

    func setHasSeenNotificationsOnboarding() {
        userDefaultsService.set(
            bool: true,
            forKey: .notificationsOnboardingSeen
        )
    }
}

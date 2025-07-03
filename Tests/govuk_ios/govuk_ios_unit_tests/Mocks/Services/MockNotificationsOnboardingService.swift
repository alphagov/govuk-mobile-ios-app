import Foundation

@testable import govuk_ios

class MockNotificationsOnboardingService: NotificationsOnboardingServiceInterface {
    var hasSeenNotificationsOnboarding: Bool = false

    func setHasSeenNotificationsOnboarding() {
        hasSeenNotificationsOnboarding = true
    }
}

import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct NotificationsOnboardingServiceTests {

    @Test
    func hasSeenNotificationsOnboarding_returnsFalseByDefault() {
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set(bool: false, forKey: .notificationsOnboardingSeen)
        let sut = NotificationsOnboardingService(userDefaults: mockUserDefaults)

        #expect(!sut.hasSeenNotificationsOnboarding)
    }

    @Test
    func setHasSeenNotificationsOnboarding_setsFlagToTrue() {
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set(bool: false, forKey: .notificationsOnboardingSeen)
        let sut = NotificationsOnboardingService(userDefaults: mockUserDefaults)

        sut.setHasSeenNotificationsOnboarding()

        let result = mockUserDefaults.bool(forKey: .notificationsOnboardingSeen)
        #expect(result)
    }
}

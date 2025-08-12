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
        let sut = NotificationsOnboardingService(userDefaultsService: mockUserDefaults)

        #expect(!sut.hasSeenNotificationsOnboarding)
    }

    @Test
    func setHasSeenNotificationsOnboarding_setsFlagToTrue() {
        let mockUserDefaults = MockUserDefaultsService()
        mockUserDefaults.set(bool: false, forKey: .notificationsOnboardingSeen)
        let sut = NotificationsOnboardingService(userDefaultsService: mockUserDefaults)

        sut.setHasSeenNotificationsOnboarding()

        let result = mockUserDefaults.bool(forKey: .notificationsOnboardingSeen)
        #expect(result)
    }
}

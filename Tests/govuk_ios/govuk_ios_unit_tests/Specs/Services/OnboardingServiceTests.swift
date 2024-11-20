import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct OnboardingServiceTests {
    @Test
    func hasSeenOnboarding_hasSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: true, forKey: .appOnboardingSeen)
        let subject = OnboardingService(userDefaults: userDefaults)

        #expect(subject.hasSeenOnboarding)
    }

    @Test
    func hasSeenOnboarding_hasntSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: false, forKey: .appOnboardingSeen)
        let subject = OnboardingService(userDefaults: userDefaults)

        #expect(subject.hasSeenOnboarding == false)
    }

    @Test
    func setHasSeenOnboarding_setsTrue() {
        let userDefaults = UserDefaults()
        let subject = OnboardingService(userDefaults: userDefaults)
        subject.setHasSeenOnboarding()

        #expect(userDefaults.bool(forKey: .appOnboardingSeen) == true)
    }

    @Test
    func fetchSlides_returnsExpectedResult() {
        let subject = OnboardingService(
            userDefaults: MockUserDefaults()
        )
        let result = subject.fetchSlides()

        #expect(result.count == 3)
    }

}

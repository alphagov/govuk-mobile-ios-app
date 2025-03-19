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
    func fetchSlides_returnsExpectedResult() async {
        let subject = OnboardingService(
            userDefaults: MockUserDefaults()
        )
        let result = await withCheckedContinuation { continuation in
            subject.fetchSlides(
                completion: {
                    continuation.resume(returning: $0)
                }
            )
        }
        switch result {
        case .success(let slides):
            #expect(slides.count == 3)
        default:
            #expect(Bool(false))
        }
    }

}

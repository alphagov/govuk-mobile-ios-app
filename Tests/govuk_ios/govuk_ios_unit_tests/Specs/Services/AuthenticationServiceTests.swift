import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AuthenticationServiceTests {
    @Test
    func hasSeenOnboarding_hasSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: true, forKey: .authenticationOnboardingSeen)
        let subject = AuthenticationOnboardingService(userDefaults: userDefaults)

        #expect(subject.hasSeenOnboarding)
    }

    @Test
    func hasSeenOnboarding_hasntSeen_returnsTrue() {
        let userDefaults = UserDefaults()
        userDefaults.set(bool: false, forKey: .authenticationOnboardingSeen)
        let subject = AuthenticationOnboardingService(userDefaults: userDefaults)

        #expect(subject.hasSeenOnboarding == false)
    }

    @Test
    func setHasSeenOnboarding_setsTrue() {
        let userDefaults = UserDefaults()
        let subject = AuthenticationOnboardingService(userDefaults: userDefaults)
        subject.setHasSeenOnboarding()

        #expect(userDefaults.bool(forKey: .authenticationOnboardingSeen) == true)
    }

    @Test
    func fetchSlides_returnsExpectedResult() async {
        let subject = AuthenticationOnboardingService(
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
            #expect(slides.count == 1)
        default:
            #expect(Bool(false))
        }
    }

}


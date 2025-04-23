import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct AuthenticationOnboardingServiceTests {
    @Test
    func setHasSeenOnboarding_setsTrue() {
        let userDefaults = MockUserDefaults()
        let sut = AuthenticationOnboardingService(userDefaults: userDefaults)
        sut.setHasSeenOnboarding()

        #expect(userDefaults.bool(forKey: .authenticationOnboardingSeen) == true)
    }

    @Test
    func shouldSkipOnboarding_featureDisabledHasntSeenOnboarding_returnsTrue() {
        let userDefaults = MockUserDefaults()
        userDefaults.set(bool: false, forKey: .authenticationOnboardingSeen)
        let sut = AuthenticationOnboardingService(userDefaults: userDefaults)

        #expect(sut.shouldSkipOnboarding)
    }

    @Test
    func shouldSkipOnboarding_featureDisabledHasSeenOnboarding_returnsTrue() {
        let userDefaults = MockUserDefaults()
        userDefaults.set(bool: true, forKey: .authenticationOnboardingSeen)
        let sut = AuthenticationOnboardingService(userDefaults: userDefaults)

        #expect(sut.shouldSkipOnboarding)
    }

    @Test
    func fetchSlides_returnsExpectedResult() async {
        let sut = AuthenticationOnboardingService(
            userDefaults: MockUserDefaults()
        )
        let result = await withCheckedContinuation { continuation in
            sut.fetchSlides(
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


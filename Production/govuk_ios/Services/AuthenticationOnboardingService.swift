import Foundation
import Onboarding

protocol AuthenticationOnboardingServiceInterface: OnboardingSlideProvider {
    var hasSeenOnboarding: Bool { get }
    var isFeatureEnabled: Bool { get }

    func setHasSeenOnboarding()
    func shouldSkipOnboarding() -> Bool
}

struct AuthenticationOnboardingService: AuthenticationOnboardingServiceInterface {
    private let userDefaults: UserDefaultsInterface

    init(userDefaults: UserDefaultsInterface) {
        self.userDefaults = userDefaults
    }

    var hasSeenOnboarding: Bool {
        userDefaults.bool(forKey: .authenticationOnboardingSeen)
    }

    var isFeatureEnabled: Bool {
        false
    }

    func shouldSkipOnboarding() -> Bool {
        hasSeenOnboarding || !isFeatureEnabled
    }

    func setHasSeenOnboarding() {
        userDefaults.set(
            bool: true,
            forKey: .authenticationOnboardingSeen
        )
    }

    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void
    ) {
        completion(.success(Onboarding.authenticationSlides))
    }
}

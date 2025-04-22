import Foundation
import Onboarding

protocol AuthenticationOnboardingServiceInterface: OnboardingSlideProvider {
    var hasSeenOnboarding: Bool { get }
    var isFeatureEnabled: Bool { get }
    var shouldSkipOnboarding: Bool { get }

    func setHasSeenOnboarding()
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

    var shouldSkipOnboarding: Bool {
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

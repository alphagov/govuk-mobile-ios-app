import Foundation
import Onboarding

protocol AuthenticationOnboardingServiceInterface: OnboardingSlideProvider {
    var shouldSkipOnboarding: Bool { get }
    func setHasSeenOnboarding()
}

struct AuthenticationOnboardingService: AuthenticationOnboardingServiceInterface {
    private let userDefaults: UserDefaultsInterface

    init(userDefaults: UserDefaultsInterface) {
        self.userDefaults = userDefaults
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

    private var hasSeenOnboarding: Bool {
        userDefaults.bool(forKey: .authenticationOnboardingSeen)
    }

    private var isFeatureEnabled: Bool {
        false
    }
}

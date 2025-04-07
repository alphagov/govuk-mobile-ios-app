import Foundation
import Onboarding

protocol AuthenticationOnboardingServiceInterface: OnboardingSlideProvider {
    var hasSeenOnboarding: Bool { get }

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

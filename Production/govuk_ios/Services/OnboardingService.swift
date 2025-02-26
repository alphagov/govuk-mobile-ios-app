import Foundation
import Onboarding

protocol OnboardingServiceInterface: OnboardingSlideProvider {
    var hasSeenOnboarding: Bool { get }

    func setHasSeenOnboarding()
}

struct OnboardingService: OnboardingServiceInterface {
    private let userDefaults: UserDefaultsInterface

    init(userDefaults: UserDefaultsInterface) {
        self.userDefaults = userDefaults
    }

    var hasSeenOnboarding: Bool {
        userDefaults.bool(forKey: .appOnboardingSeen)
    }

    func setHasSeenOnboarding() {
        userDefaults.set(
            bool: true,
            forKey: .appOnboardingSeen
        )
    }

    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void
    ) {
        completion(.success(Onboarding.appSlides))
    }
}

import Foundation
import Onboarding

protocol AuthenticationOnboardingServiceInterface: OnboardingSlideProvider {
    var isFeatureEnabled: Bool { get }
}

struct AuthenticationOnboardingService: AuthenticationOnboardingServiceInterface {
    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], Error>) -> Void
    ) {
        completion(.success(Onboarding.authenticationSlides))
    }

    var isFeatureEnabled: Bool {
        false
    }
}

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
        let slides: [any OnboardingSlideViewModelInterface] = [
            OnboardingSlideAnimationViewModel(
                slide: .init(
                    image: "onboarding_personalisation",
                    title: String.onboarding.localized("personalisationTitle"),
                    body: String.onboarding.localized("personalisationBody"),
                    name: "Onboarding_A"
                ),
                primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
                secondaryButtonTitle: String.onboarding.localized("secondaryButtonTitle")
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_2",
                    title: String.onboarding.localized("pagesYouveVisitedTitle"),
                    body: String.onboarding.localized("pagesYouveVisitedBody"),
                    name: "Onboarding_B"
                ),
                primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
                secondaryButtonTitle: String.onboarding.localized("secondaryButtonTitle")
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_3",
                    title: String.onboarding.localized("tailoredToYouTitle"),
                    body: String.onboarding.localized("tailoredToYouBody"),
                    name: "Onboarding_C"
                ),
                primaryButtonTitle: String.onboarding.localized("doneButtonTitle"),
                secondaryButtonTitle: ""
            )
        ]
        completion(.success(slides))
    }
}

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
                    title: "Get things done on the go",
                    body:
                    """
                    Access government services and information on your phone using the GOV.UK app
                    """,
                    name: "Onboarding_A"
                )
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_2",
                    title: "Quickly get back to previous pages",
                    body: """
                        Pages you’ve visited are saved so you can easily return to them
                        """,
                    name: "Onboarding_B"
                )
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_3",
                    title: "Tailored to you",
                    body: """
                        Choose topics that are relevant to you so you can find what you need faster
                        """,
                    name: "Onboarding_C"
                )
            )
        ]
        completion(.success(slides))
    }
}

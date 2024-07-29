import Foundation
import Onboarding

protocol OnboardingServiceInterface {
    var hasSeenOnboarding: Bool { get }

    func setHasSeenOnboarding()
    func fetchSlides() -> [OnboardingSlide]
}

struct OnboardingService: OnboardingServiceInterface {
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    var hasSeenOnboarding: Bool {
        userDefaults.bool(forKey: .appOnboardingSeen)
    }

    func setHasSeenOnboarding() {
        userDefaults.set(
            bool: true,
            forkey: .appOnboardingSeen
        )
    }

    func fetchSlides() -> [OnboardingSlide] {
        return [
            .init(
                image: "onboarding_placeholder_screen_1",
                title: "Get things done on the go",
                body: """
                Access government services and information on your phone using the GOV.UK app
                """
            ),
            .init(
                image: "onboarding_placeholder_screen_2",
                title: "Quickly get back to previous pages",
                body: """
                Pages you’ve visited are saved so you can easily return to them
                """
            ),
            .init(
                image: "onboarding_placeholder_screen_3",
                title: "Tailored to you",
                body: """
                Choose topics that are relevant to you so you can find what you need faster
                """
            )
        ]
    }
}

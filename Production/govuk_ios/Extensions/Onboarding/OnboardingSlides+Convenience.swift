import Foundation
import Onboarding
import GOVKit

extension Onboarding {
    static var authenticationSlide: OnboardingSlideImageViewModel {
        OnboardingSlideImageViewModel(
            slide: .init(
                image: "onboarding_screen_1", // waiting on OL to confirm image
                title: String.onboarding.localized("authenticationTitle"),
                body: String.onboarding.localized("authenticationBody"),
                name: "AuthenticationOnboardingScreen"
            ),
            primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
            primaryButtonAccessibilityHint: nil,
            secondaryButtonTitle: "",
            secondaryButtonAccessibilityHint: nil
        )
    }

    static var authenticationSlides: [any OnboardingSlideViewModelInterface] {
        [
            authenticationSlide
        ]
    }
}

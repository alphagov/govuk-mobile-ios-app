import Foundation
import Onboarding
import GOVKit

extension Onboarding {
    static var appSlides: [any OnboardingSlideViewModelInterface] {
        [
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_1",
                    title: String.onboarding.localized("personalisationTitle"),
                    body: String.onboarding.localized("personalisationBody"),
                    name: "Onboarding_A"
                ),
                primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
                primaryButtonAccessibilityHint: nil,
                secondaryButtonTitle: String.onboarding.localized("secondaryButtonTitle"),
                secondaryButtonAccessibilityHint: nil
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_2",
                    title: String.onboarding.localized("pagesYouveVisitedTitle"),
                    body: String.onboarding.localized("pagesYouveVisitedBody"),
                    name: "Onboarding_B"
                ),
                primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
                primaryButtonAccessibilityHint: nil,
                secondaryButtonTitle: String.onboarding.localized("secondaryButtonTitle"),
                secondaryButtonAccessibilityHint: nil
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_3",
                    title: String.onboarding.localized("tailoredToYouTitle"),
                    body: String.onboarding.localized("tailoredToYouBody"),
                    name: "Onboarding_C"
                ),
                primaryButtonTitle: String.onboarding.localized("doneButtonTitle"),
                primaryButtonAccessibilityHint: nil,
                secondaryButtonTitle: "",
                secondaryButtonAccessibilityHint: nil
            )
        ]
    }

    static var notificationSlide: OnboardingSlideAnimationViewModel {
        OnboardingSlideAnimationViewModel(
            slide: .init(
                image: "onboarding_stay_updated",
                title: String.notifications.localized("onboardingTitle"),
                body: String.notifications.localized("onboardingBody"),
                name: "NotificationsOnboardingScreen"
            ),
            primaryButtonTitle: String.notifications.localized("onboardingAcceptButtonTitle"),
            primaryButtonAccessibilityHint: nil,
            secondaryButtonTitle: String.notifications.localized("onboardingSkipButtonTitle"),
            secondaryButtonAccessibilityHint: nil
        )
    }

    static var notificationSlides: [any OnboardingSlideViewModelInterface] {
        [
            notificationSlide
        ]
    }

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

import Foundation
import Onboarding
import GOVKit

extension Onboarding {
    static var appSlides: [any OnboardingSlideViewModelInterface] {
        let primaryAccessibilityHint = String.onboarding.localized("primaryButtonAccessibilityHint")
        let finalPrimaryAccessibilityHint = String.onboarding
            .localized("primaryButtonLastSlideAccessibilityHint")
        let secondaryAccessibilityHint = String.onboarding.localized("skipButtonAcessibilityHint")
        return [
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_1",
                    title: String.onboarding.localized("personalisationTitle"),
                    body: String.onboarding.localized("personalisationBody"),
                    name: "Onboarding_A"
                ),
                primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
                primaryButtonAccessibilityHint: primaryAccessibilityHint,
                secondaryButtonTitle: String.onboarding.localized("secondaryButtonTitle"),
                secondaryButtonAccessibilityHint: secondaryAccessibilityHint
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_2",
                    title: String.onboarding.localized("pagesYouveVisitedTitle"),
                    body: String.onboarding.localized("pagesYouveVisitedBody"),
                    name: "Onboarding_B"
                ),
                primaryButtonTitle: String.onboarding.localized("continueButtonTitle"),
                primaryButtonAccessibilityHint: primaryAccessibilityHint,
                secondaryButtonTitle: String.onboarding.localized("secondaryButtonTitle"),
                secondaryButtonAccessibilityHint: secondaryAccessibilityHint
            ),
            OnboardingSlideImageViewModel(
                slide: .init(
                    image: "onboarding_screen_3",
                    title: String.onboarding.localized("tailoredToYouTitle"),
                    body: String.onboarding.localized("tailoredToYouBody"),
                    name: "Onboarding_C"
                ),
                primaryButtonTitle: String.onboarding.localized("doneButtonTitle"),
                primaryButtonAccessibilityHint: finalPrimaryAccessibilityHint,
                secondaryButtonTitle: "",
                secondaryButtonAccessibilityHint: nil
            )
        ]
    }

    static var notificationSlides: [any OnboardingSlideViewModelInterface] {
        [
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
        ]
    }
}

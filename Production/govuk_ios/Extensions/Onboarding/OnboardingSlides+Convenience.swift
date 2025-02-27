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
                secondaryButtonTitle: String.notifications.localized("onboardingSkipButtonTitle")
            )
        ]
    }
}

import Foundation
import Onboarding

@testable import govuk_ios

class MockOnBoardingService: OnboardingServiceInterface {
    
    var hasSeenOnboarding = false
    
    func setHasSeenOnboarding() {
        self.hasSeenOnboarding = true
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

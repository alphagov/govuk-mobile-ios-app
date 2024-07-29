import Foundation
import Onboarding

@testable import govuk_ios

class MockOnboardingService: OnboardingServiceInterface {

    var _stubbedHasSeenOnboarding: Bool = false
    var hasSeenOnboarding: Bool {
        _stubbedHasSeenOnboarding
    }

    var _setHasSeenOnboardingCalled: Bool = false
    func setHasSeenOnboarding() {
        _setHasSeenOnboardingCalled = true
    }
    
    var _stubbedFetchSlidesSlides: [OnboardingSlide]?
    func fetchSlides() -> [OnboardingSlide] {
        _stubbedFetchSlidesSlides ?? []
    }
}

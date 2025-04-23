import Foundation
import UIKit

import Onboarding

@testable import govuk_ios

class MockAuthenticationOnboardingService: AuthenticationOnboardingServiceInterface {
    var _stubbedShouldSkipOnboarding: Bool = false
    var shouldSkipOnboarding: Bool {
        _stubbedShouldSkipOnboarding
    }

    var _setHasSeenOnboardingCalled: Bool = false
    func setHasSeenOnboarding() {
        _setHasSeenOnboardingCalled = true
    }

    var _stubbedFetchSlidesSlides: [OnboardingSlide]?
    func fetchSlides() -> [OnboardingSlide] {
        _stubbedFetchSlidesSlides ?? []
    }

    var _receivedFetchSlidesCompletion: ((Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void)?
    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void
    ) {
        _receivedFetchSlidesCompletion = completion
    }
}



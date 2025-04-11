import Foundation
import UIKit

import Onboarding

@testable import govuk_ios

class MockAuthenticationOnboardingService: AuthenticationOnboardingServiceInterface {
    func shouldSkipOnboarding() -> Bool {
        !_stubbedFeatureEnabled || _stubbedHasSeenOnboarding
    }
    
    var _stubbedFeatureEnabled: Bool = true
    var isFeatureEnabled: Bool {
        _stubbedFeatureEnabled
    }

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

    var _receivedFetchSlidesCompletion: ((Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void)?
    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void
    ) {
        _receivedFetchSlidesCompletion = completion
    }
}



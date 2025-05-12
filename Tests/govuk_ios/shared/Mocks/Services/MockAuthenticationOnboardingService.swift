import Foundation
import UIKit

import Onboarding

@testable import govuk_ios

class MockAuthenticationOnboardingService: AuthenticationOnboardingServiceInterface {
    var isFeatureEnabled: Bool = true

    var _receivedFetchSlidesCompletion: ((Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void)?
    func fetchSlides(
        completion: @escaping (Result<[any OnboardingSlideViewModelInterface], any Error>) -> Void
    ) {
        _receivedFetchSlidesCompletion = completion
    }
}



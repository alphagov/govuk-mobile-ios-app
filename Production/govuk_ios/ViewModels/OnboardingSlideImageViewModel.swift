import Foundation
import SwiftUICore

import Onboarding

class OnboardingSlideImageViewModel: OnboardingSlideViewModel {
    override var image: AnyView {
        AnyView(
            Image(slide.image)
        )
    }
}

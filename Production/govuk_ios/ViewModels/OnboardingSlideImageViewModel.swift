import Foundation
import SwiftUICore

import Onboarding

class OnboardingSlideImageViewModel: OnboardingSlideViewModelInterface {
    let title: String
    let body: String
    let name: String
    let contentView: AnyView

    init(slide: OnboardingSlide) {
        self.title = slide.title
        self.body = slide.body
        self.name = slide.name
        self.contentView = AnyView(
            Image(slide.image)
        )
    }

    func willShow() {
        print("Show \(name)")
    }
}

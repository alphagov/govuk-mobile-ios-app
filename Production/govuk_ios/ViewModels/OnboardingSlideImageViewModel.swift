import Foundation
import SwiftUICore

import Onboarding

class OnboardingSlideImageViewModel: OnboardingSlideViewModelInterface {
    let title: String
    let body: String
    let name: String
    let contentView: AnyView
    let primaryButtonTitle: String

    init(slide: OnboardingSlide,
         primaryButtonTitle: String) {
        self.title = slide.title
        self.body = slide.body
        self.name = slide.name
        self.primaryButtonTitle = primaryButtonTitle
        self.contentView = AnyView(
            Image(slide.image)
        )
    }

    func didAppear() { }
}

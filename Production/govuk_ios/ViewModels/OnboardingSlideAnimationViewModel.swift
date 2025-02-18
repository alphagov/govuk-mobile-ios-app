import Foundation
import SwiftUICore
import Combine

import Onboarding

import Lottie

class OnboardingSlideAnimationViewModel: OnboardingSlideViewModelInterface {
    let title: String
    let body: String
    let name: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String

    private lazy var lottieView = LottieView(animation: .named(slide.image))
        .resizable()
    @Published private(set) var contentView: AnyView = AnyView(EmptyView())
    var contentViewUpdatePublisher: AnyPublisher<AnyView, Never> {
        $contentView.eraseToAnyPublisher()
    }

    public let slide: OnboardingSlide

    init(slide: OnboardingSlide,
         primaryButtonTitle: String,
         secondaryButtonTitle: String) {
        self.slide = slide
        self.title = slide.title
        self.body = slide.body
        self.name = slide.name
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.contentView = AnyView(
            lottieView
        )
    }

    func didAppear() {
        contentView = AnyView(
            lottieView.playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
        )
    }
}

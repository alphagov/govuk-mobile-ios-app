import Foundation
import SwiftUICore
import Combine

import Onboarding

import Lottie

class OnboardingSlideAnimationViewModel: OnboardingSlideViewModelInterface {
    let title: String
    let body: String
    let name: String
    @Published var contentView: AnyView = AnyView(EmptyView())
    var contentViewPublisher: AnyPublisher<AnyView, Never> {
        $contentView.eraseToAnyPublisher()
    }

    @Published var playbackMode: LottiePlaybackMode = .paused(at: .progress(0))

    public let slide: OnboardingSlide

    init(slide: OnboardingSlide) {
        self.slide = slide
        self.title = slide.title
        self.body = slide.body
        self.name = slide.name
    }

    func startAnimation() {
        contentView = AnyView(
            LottieView(animation: .named(slide.image))
                .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
                .resizable())
    }
}

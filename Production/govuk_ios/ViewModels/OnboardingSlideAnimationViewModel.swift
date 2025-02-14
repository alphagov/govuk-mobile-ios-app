import Foundation
import SwiftUICore

import Onboarding

import Lottie

class OnboardingSlideAnimationViewModel: OnboardingSlideViewModel {
    @Published var playbackMode: LottiePlaybackMode = .paused(at: .progress(0))

    override var image: AnyView {
        AnyView(
            LottieView(animation: .named(slide.image))
                .playbackMode(playbackMode)
                .resizable()
        )
    }

    override func startAnimation() {
        playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
    }
}

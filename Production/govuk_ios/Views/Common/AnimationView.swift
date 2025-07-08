import Foundation
import UIKit

import Lottie

@MainActor
class AnimationView: UIView {
    @Inject(\.lottieConfiguration) private var config: LottieConfiguration
    @Inject(\.accessibilityManager) private var accessibilityManager: AccessibilityManagerInterface

    private lazy var internalAnimationView: LottieAnimationView = LottieAnimationView(
        name: resourceName,
        configuration: config
    )

    private let resourceName: String
    private let reducedAnimationProgress: CGFloat

    init(resourceName: String,
         reducedAnimationProgress: CGFloat = 0) {
        self.resourceName = resourceName
        self.reducedAnimationProgress = reducedAnimationProgress
        super.init(frame: .zero)
        configureUI()
        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        internalAnimationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(internalAnimationView)
    }

    private func configureConstraints() {
        internalAnimationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        internalAnimationView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        internalAnimationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        internalAnimationView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func animateIfAvailable(completion: @escaping () -> Void) {
        if accessibilityManager.animationsEnabled {
            beginAnimation(completion: completion)
        } else {
            pauseTransition(completion: completion)
        }
    }

    var hasAnimationBegun: Bool {
        internalAnimationView.isAnimationPlaying ||
        internalAnimationView.currentProgress > 0
    }

    private func beginAnimation(completion: @escaping () -> Void) {
        internalAnimationView.play(
            completion: { finished in
                guard finished else { return }
                completion()
            }
        )
    }

    private func pauseTransition(completion: @escaping () -> Void) {
        internalAnimationView.currentProgress = reducedAnimationProgress
        DispatchQueue.main
            .asyncAfter(deadline: .now() + 2) {
                completion()
            }
    }
}

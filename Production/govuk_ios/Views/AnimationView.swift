import Foundation
import UIKit

import Lottie

class AnimationView: UIView {
    @Inject(\.lottieConfiguration) private var config: LottieConfiguration

    private lazy var internalAnimationView: LottieAnimationView = LottieAnimationView(
        name: resourceName,
        configuration: config
    )

    private let resourceName: String

    init(resourceName: String) {
        self.resourceName = resourceName
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
        guard UIView.areAnimationsEnabled
        else { return completion() }
        internalAnimationView.play(
            completion: { finished in
                guard finished else { return }
                completion()
            }
        )
    }
}

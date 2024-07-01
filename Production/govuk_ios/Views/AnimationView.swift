import Foundation
import UIKit

import Lottie

class AnimationView: UIView {
    private lazy var animationView = LottieAnimationView(
        name: resourceName,
        configuration: .init(renderingEngine: .mainThread)
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
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
    }

    private func configureConstraints() {
        animationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        animationView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        animationView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }

    func animateIfAvailable(completion: @escaping () -> Void) {
        guard UIView.areAnimationsEnabled
        else { return completion() }
        animationView.play(
            completion: { finished in
                guard finished else { return }
                completion()
            }
        )
    }
}

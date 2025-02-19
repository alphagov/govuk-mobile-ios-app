import Foundation
import UIKit

class FadeAnimation: NSObject,
                     UIViewControllerAnimatedTransitioning {
    let duration = 0.8
    let animationsManager: AnimationsManager

    init(animationsManager: AnimationsManager) {
        self.animationsManager = animationsManager
    }

    func transitionDuration(
        using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else { return }
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        animationsManager.animate(
            withDuration: duration,
            animations: {
                toView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}

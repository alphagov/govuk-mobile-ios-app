import Foundation
import UIKit

class PopAnimation: NSObject,
                    UIViewControllerAnimatedTransitioning {
    let duration = 0.8
    var presenting = true
    var originFrame = CGRect.zero

    func transitionDuration(
        using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
            return duration
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to),
        let recipeView = presenting ? toView : transitionContext.view(forKey: .from)
        else { return }

        let initialFrame = presenting ? originFrame : recipeView.frame
        let finalFrame = presenting ? recipeView.frame : originFrame
        let xScaleFactor = presenting ?
        initialFrame.width / finalFrame.width :
        finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ?
        initialFrame.height / finalFrame.height :
        finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
            recipeView.transform = scaleTransform
            recipeView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            recipeView.clipsToBounds = true
        }

        recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        recipeView.layer.masksToBounds = true
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(recipeView)

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            animations: {
                recipeView.transform = self.presenting ? .identity : scaleTransform
                recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                recipeView.layer.cornerRadius = !self.presenting ? 20.0 : 0.0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}

import Foundation
import UIKit

class CustomModalTransitionDelegate: NSObject,
                                     UIViewControllerTransitioningDelegate {
    private let animation: ModalAnimation

    init(animation: ModalAnimation) {
        self.animation = animation
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
            return animation.returnAnimation
        }
}

import Foundation
import UIKit

class CustomModalTransitionDelegate: NSObject,
                                     UIViewControllerTransitioningDelegate {
    private let animation: ModalAnimations

    init(animation: ModalAnimations) {
        self.animation = animation
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
            return nil
        }
}

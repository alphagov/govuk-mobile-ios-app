import Foundation
import UIKit

enum ModalAnimations {
    case fadeAnimation

    var returnAnimation: UIViewControllerAnimatedTransitioning {
        switch self {
        case .fadeAnimation:
            return FadeAnimation(animationsManager: AnimationsManager())
        }
    }
}

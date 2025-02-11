import Foundation
import UIKit

enum ModalAnimations {
    case popAnimation
    case fadeAnimation

    var returnAnimation: UIViewControllerAnimatedTransitioning {
        switch self {
        case .popAnimation:
            return PopAnimation()
        case .fadeAnimation:
            return FadeAnimation()
        }
    }
}

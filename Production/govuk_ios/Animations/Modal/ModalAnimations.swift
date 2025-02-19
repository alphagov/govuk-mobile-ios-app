import Foundation
import UIKit

enum ModalAnimation {
    case fade

    var returnAnimation: UIViewControllerAnimatedTransitioning {
        switch self {
        case .fade:
            return FadeAnimation(animationsManager: AnimationsManager())
        }
    }
}

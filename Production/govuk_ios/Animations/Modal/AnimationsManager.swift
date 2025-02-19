import Foundation
import UIKit

struct AnimationsManager {
    @Inject(\.accessibilityManager) private var accessibilityManager: AccessibilityManagerInterface

    func animate(
        withDuration duration: TimeInterval,
        delay: CGFloat = 0.8,
        usingSpringWithDamping: CGFloat = 1.0,
        initialSpringVelocity: CGFloat = 1.0,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)?) {
            guard accessibilityManager.animationsEnabled else {
                animations()
                completion?(true)
                return
            }
            UIView.animate(
                withDuration: duration,
                delay: delay,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                animations: animations,
                completion: completion
            )
        }
}

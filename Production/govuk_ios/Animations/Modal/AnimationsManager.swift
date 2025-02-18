import Foundation
import UIKit

struct AnimationsManager {
    @Inject(\.accessibilityManager) private var accessibilityManager: AccessibilityManagerInterface

    func animate(
        withDuration duration: TimeInterval,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)?) {
            guard accessibilityManager.animationsEnabled else {
                animations()
                completion?(true)
                return
            }
            UIView.animate(
                withDuration: duration,
                delay: 0.8,
                usingSpringWithDamping: 1.0,
                initialSpringVelocity: 1.0,
                animations: animations,
                completion: completion
            )
        }
}

import UIKit

extension UIButton {
    func removeAllActions() {
        enumerateEventHandlers { action, targetAction, event, end in
            if let action {
                self.removeAction(action, for: event)
            }

            if let (target, selector) = targetAction {
                self.removeTarget(target, action: selector, for: event)
            }

            end = true
        }
    }
}

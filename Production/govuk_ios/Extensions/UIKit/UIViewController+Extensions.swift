import Foundation
import UIKit

protocol ResetsToDefault {
    func resetState()
}

extension UIViewController {
    func viewWillReAppear(isAppearing: Bool = true,
                          animated: Bool = false) {
        beginAppearanceTransition(isAppearing, animated: animated)
        endAppearanceTransition()
    }

    func addController(_ content: UIViewController) {
        addChild(content)
        view.addSubview(content.view)
        content.didMove(toParent: self)
    }

    func removeController(_ content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
}

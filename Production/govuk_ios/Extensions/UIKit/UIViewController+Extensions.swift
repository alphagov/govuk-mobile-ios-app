import Foundation
import UIKit

protocol ContentScrollable {
    func scrollToTop()
}

extension UIViewController {
    func viewWillReAppear(isAppearing: Bool = true,
                          animated: Bool = false) {
        beginAppearanceTransition(isAppearing, animated: animated)
        endAppearanceTransition()
    }
}

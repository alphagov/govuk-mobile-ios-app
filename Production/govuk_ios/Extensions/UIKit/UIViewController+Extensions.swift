import Foundation
import UIKit

extension UIViewController {
    func viewWillReAppear(isAppearing: Bool = true,
                          animated: Bool = false) {
        beginAppearanceTransition(isAppearing, animated: animated)
        endAppearanceTransition()
    }
}

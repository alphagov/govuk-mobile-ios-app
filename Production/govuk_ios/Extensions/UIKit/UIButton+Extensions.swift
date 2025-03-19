import Foundation
import UIKit

extension UIButton {
    var setEnabled: (Bool) -> Void {
        return { [weak self] enabled in
            self?.isEnabled = enabled
        }
    }
}

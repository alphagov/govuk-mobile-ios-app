import Foundation
import UIKit

extension UIEdgeInsets {
    init(all value: CGFloat) {
        self.init(
            top: value,
            left: value,
            bottom: value,
            right: value
        )
    }
}

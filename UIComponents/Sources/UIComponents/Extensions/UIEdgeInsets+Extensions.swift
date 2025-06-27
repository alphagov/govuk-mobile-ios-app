import UIKit

extension UIEdgeInsets {
    var horizontal: CGFloat {
        left + right
    }

    var vertical: CGFloat {
        top + bottom
    }
}

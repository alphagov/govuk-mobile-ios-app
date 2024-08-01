import Foundation
import UIKit

extension UIScrollView {
    var verticalScroll: CGFloat {
        adjustedContentInset.top + contentOffset.y
    }
}

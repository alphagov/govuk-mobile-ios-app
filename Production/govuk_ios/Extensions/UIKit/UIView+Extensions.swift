import Foundation
import UIKit

extension UIView {
    static var identifierString: String {
        let fullIdentifier = String(describing: self)
        return fullIdentifier.components(separatedBy: "<")[0]
    }
}

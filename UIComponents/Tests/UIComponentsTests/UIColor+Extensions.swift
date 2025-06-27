import Foundation
import UIKit

extension UIColor {

    var lightMode: UIColor? {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }

    var darkMode: UIColor? {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }

}

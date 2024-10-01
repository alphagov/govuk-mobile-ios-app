import Foundation
import UIKit

extension UINavigationBarAppearance {
    static var govUK: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.govUK.bodySemibold
        ]
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.govUK.fills.surfaceModal
        appearance.buttonAppearance = .govUK
        appearance.backButtonAppearance = .govUK
        return appearance
    }
}

extension UIBarButtonItemAppearance {
    static var govUK: UIBarButtonItemAppearance {
        let appearance = UIBarButtonItemAppearance()
        appearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.govUK.text.link
        ]
        return appearance
    }
}

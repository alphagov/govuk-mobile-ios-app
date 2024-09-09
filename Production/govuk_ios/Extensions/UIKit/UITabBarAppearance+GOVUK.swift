import Foundation
import UIKit
import UIComponents

extension UINavigationBarAppearance {
    static var govUK: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.govUK.bodySemibold
        ]
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = GOVUKColors.fills.surfaceModal
        appearance.buttonAppearance = .govUK
        return appearance
    }
}

extension UIBarButtonItemAppearance {
    static var govUK: UIBarButtonItemAppearance {
        let appearance = UIBarButtonItemAppearance()
        appearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: GOVUKColors.text.link
        ]
        return appearance
    }
}

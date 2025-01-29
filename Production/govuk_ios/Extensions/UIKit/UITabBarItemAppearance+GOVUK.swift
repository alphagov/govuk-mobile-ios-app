import Foundation
import UIKit

extension UITabBarItemAppearance {
    static var govUK: UITabBarItemAppearance {
        let appearance = UITabBarItemAppearance()

        appearance.selected.iconColor = UIColor.govUK.text.link
        appearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.govUK.text.link
        ]

        appearance.normal.iconColor = UIColor.govUK.text.secondary
        appearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.govUK.text.secondary
        ]
        return appearance
    }
}

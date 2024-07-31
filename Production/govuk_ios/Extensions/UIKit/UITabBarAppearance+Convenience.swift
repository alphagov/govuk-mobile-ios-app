import Foundation
import UIKit

extension UITabBarAppearance {
    static var govUK: UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = UIColor.primaryDivider
        appearance.backgroundColor = UIColor.govUK.fills.surfaceFixedContainer
        appearance.inlineLayoutAppearance = .govUK
        appearance.stackedLayoutAppearance = .govUK
        appearance.compactInlineLayoutAppearance = .govUK
        return appearance
    }
}

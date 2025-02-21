import Foundation
import UIKit

extension UINavigationBarAppearance {
    public static var govUK: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.govUK.fills.surfaceHomeHeaderBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.govUK.text.header
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.govUK.text.header
        ]
        return appearance
    }

    public static var standardScroll: UINavigationBarAppearance {
        let standardScrollAppearance = UINavigationBarAppearance()
        standardScrollAppearance.configureWithTransparentBackground()
        standardScrollAppearance.backgroundColor = UIColor.govUK.fills.surfaceBackground
        return standardScrollAppearance
    }

    public static var standard: UINavigationBarAppearance {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        return standardAppearance
    }
}

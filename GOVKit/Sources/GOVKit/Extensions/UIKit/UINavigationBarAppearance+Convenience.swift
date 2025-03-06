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
}

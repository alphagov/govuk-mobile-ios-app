import Foundation
import UIKit

extension UITabBarController {
    static var govUK: UITabBarController {
        let controller = BaseTabBarController()
        controller.tabBar.standardAppearance = .govUK
        controller.tabBar.scrollEdgeAppearance = .govUK
        return controller
    }
}

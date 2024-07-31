import Foundation
import UIKit

extension UITabBarController {
    static var govUK: UITabBarController {
        let controller = UITabBarController()
        controller.tabBar.standardAppearance = .govUK
        if #available(iOS 15.0, *) {
            controller.tabBar.scrollEdgeAppearance = .govUK
        }
        return controller
    }
}

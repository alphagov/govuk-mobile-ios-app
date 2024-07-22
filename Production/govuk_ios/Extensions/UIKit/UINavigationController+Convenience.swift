import UIKit
import Foundation

extension UINavigationController {
    static var home: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .home
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }

    static var settings: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .settings
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}

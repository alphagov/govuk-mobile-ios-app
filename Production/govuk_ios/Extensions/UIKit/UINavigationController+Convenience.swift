import UIKit
import Foundation

extension UINavigationController {
    static var home: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .home
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.setGovUKAppearance()
        return navigationController
    }

    static var settings: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .settings
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.setGovUKAppearance()
        return navigationController
    }

    static var chat: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .chat
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationBar.prefersLargeTitles = false
        return navigationController
    }
}

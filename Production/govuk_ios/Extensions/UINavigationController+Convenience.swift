import UIKit
import Foundation

extension UINavigationController {

    static var red: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .red
        return navigationController
    }

    static var blue: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .blue
        return navigationController
    }

    static var green: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = .green
        return navigationController
    }

}

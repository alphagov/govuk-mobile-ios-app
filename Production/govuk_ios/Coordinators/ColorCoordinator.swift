import UIKit
import Foundation

class ColorCoordinator {

    private let navigationController: UINavigationController
    private let color: UIColor
    private let title: String

    init(navigationController: UINavigationController,
         color: UIColor,
         title: String) {
        self.color = color
        self.title = title
        self.navigationController = navigationController
    }

    func start() {
        let viewController = ViewController(
            color: color,
            tabTitle: title
        )
        navigationController.setViewControllers(
            [viewController],
            animated: false
        )
    }

}

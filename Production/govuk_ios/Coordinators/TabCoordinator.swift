import UIKit
import Foundation

class TabCoordinator {
    private let navigationController: UINavigationController

    private lazy var redNavigationController = UINavigationController.red
    private lazy var redCoordinator = ColorCoordinator(
        navigationController: redNavigationController,
        color: .red,
        title: "Red"
    )

    private lazy var blueNavigationController = UINavigationController.blue
    private lazy var blueCoordinator = ColorCoordinator(
        navigationController: blueNavigationController,
        color: .blue,
        title: "Blue"
    )

    private lazy var greenNavigationController = UINavigationController.green
    private lazy var greenCoordinator = ColorCoordinator(
        navigationController: greenNavigationController,
        color: .green,
        title: "Green"
    )

    private var coordinators: [ColorCoordinator] {
        [
            redCoordinator,
            blueCoordinator,
            greenCoordinator
        ]
    }

    private lazy var tabController = {
        let controller = UITabBarController()
        var appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        controller.tabBar.standardAppearance = appearance
        return controller
    }()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabs()
        coordinators.forEach { $0.start() }
    }

    private func showTabs() {
        tabController.viewControllers = [
            redNavigationController,
            blueNavigationController,
            greenNavigationController
        ]
        navigationController.setViewControllers(
            [tabController],
            animated: false
        )
    }
}

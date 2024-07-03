import UIKit
import Foundation

class TabCoordinator: BaseCoordinator {
    private lazy var redCoordinator = coordinatorBuilder.red
    private lazy var blueCoordinator = coordinatorBuilder.blue(
        requestFocus: tabRequestedFocus
    )
    private lazy var greenCoordinator = coordinatorBuilder.green

    private var coordinators: [BaseCoordinator] {
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

    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        showTabs()
        coordinators.forEach {
            start($0, url: url)
        }
    }

    private func showTabs() {
        tabController.viewControllers = coordinators.map { $0.root }
        set([tabController], animated: false)
    }

    private var tabRequestedFocus: (UINavigationController) -> Void {
        return { [weak self] navigationController in
            let viewControllers = self?.tabController.viewControllers
            self?.tabController.selectedIndex = viewControllers?.firstIndex(of: navigationController) ?? 0
        }
    }
}

import UIKit
import Foundation

class TabCoordinator: BaseCoordinator {
    private lazy var redCoordinator = coordinatorBuilder.red
    private lazy var blueCoordinator = coordinatorBuilder.blue
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
    private let url: String?

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController, url: String?) {
        self.coordinatorBuilder = coordinatorBuilder
        self.url = url
        super.init(navigationController: navigationController)
    }

    override func start() {
        if let url = url {
            handleDeepLink(url: url)
        }
        showTabs()
        coordinators.forEach {
            $0.parentCoordinator = self
            childCoordinators.append($0)
            $0.start()
        }
    }

    private func showTabs() {
        tabController.viewControllers = coordinators.map { $0.root }
        set([tabController], animated: false)
    }

    override func handleDeepLink(url: String) {
        guard let path = URLComponents(string: String(describing: url))?.path
                , let coordinatorForPath = coordinators.first(where: {$0.canHandleLinks(path: path)}) else { return }
        coordinatorForPath.handleDeepLink(url: path)
    }
}

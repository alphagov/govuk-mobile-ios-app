import UIKit
import Foundation

typealias TabItemCoordinator = BaseCoordinator & DeeplinkRouteProvider

class TabCoordinator: BaseCoordinator {
    private lazy var homeCoordinator = coordinatorBuilder.home
    private lazy var settingsCoordinator = coordinatorBuilder.settings

    private var coordinators: [TabItemCoordinator] {
        [
            homeCoordinator,
            settingsCoordinator
        ]
    }

    private lazy var tabController = {
        let controller = UITabBarController()
        var appearance = UITabBarAppearance()
        controller.tabBar.backgroundColor = .primaryBackground
        appearance.configureWithOpaqueBackground()
        controller.tabBar.standardAppearance = appearance
        controller.tabBar.layer.shadowRadius = 0.8
        controller.tabBar.layer.shadowOffset = .zero
        controller.tabBar.layer.shadowOpacity = 1
        controller.tabBar.layer.shadowColor = UIColor.primaryDivider.cgColor
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
        guard let url = url
        else { return }
        handleDeeplink(url: url)
    }

    private func handleDeeplink(url: URL) {
        tabController.dismiss(animated: true)

        let route = coordinators
            .lazy
            .compactMap { $0.route(for: url) }
            .first

        if let route = route {
            selectTabIndex(for: route.parent.root)
            route.action()
        } else {
            presentDeeplinkError()
        }
    }

    private func presentDeeplinkError() {
        tabController.present(
            UIAlertController.unhandledDeeplinkAlert,
            animated: true
        )
    }

    private func showTabs() {
        tabController.viewControllers = coordinators.map { $0.root }

        set([tabController], animated: false)

        coordinators.forEach { start($0) }
    }

    private func selectTabIndex(for navigationController: UINavigationController) {
        let index = tabController.viewControllers?.firstIndex(of: navigationController)
        tabController.selectedIndex = index ?? 0
    }
}

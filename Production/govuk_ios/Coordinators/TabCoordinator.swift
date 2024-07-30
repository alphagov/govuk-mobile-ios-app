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
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = UIColor.primaryDivider
        appearance.backgroundColor = UIColor.govUK.fills.surfaceFixedContainer
        controller.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            controller.tabBar.scrollEdgeAppearance = appearance
        }
        controller.tabBar.tintColor = .linkBlue
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

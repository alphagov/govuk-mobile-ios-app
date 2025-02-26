import UIKit
import Foundation
import GOVKit

typealias TabItemCoordinator = BaseCoordinator
& DeeplinkRouteProvider
& TabItemCoordinatorInterface

protocol TabItemCoordinatorInterface {
    func didReselectTab()
}

class TabCoordinator: BaseCoordinator,
                      UITabBarControllerDelegate {
    private lazy var homeCoordinator = coordinatorBuilder.home
    private lazy var settingsCoordinator = coordinatorBuilder.setttings(
        dissmissAction: dismissAction
    )
    private var currentTabIndex = 0

    private var coordinators: [TabItemCoordinator] {
        [
            homeCoordinator,
            settingsCoordinator
        ]
    }

    private lazy var tabController = UITabBarController.govUK
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let dismissAction: () -> Void

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface,
         dissmissAction: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.analyticsService = analyticsService
        self.dismissAction = dissmissAction
        super.init(navigationController: navigationController)
        tabController.delegate = self
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

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        guard let title = viewController.tabBarItem.title else { return }
        let event = AppEvent.tabNavigation(text: title)
        analyticsService.track(event: event)
        if currentTabIndex == tabBarController.selectedIndex {
            coordinators[currentTabIndex].didReselectTab()
        }
        currentTabIndex = tabBarController.selectedIndex
    }
}

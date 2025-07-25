import UIKit
import Foundation
import GOVKit

typealias TabItemCoordinator = BaseCoordinator
& DeeplinkRouteProvider
& TabItemCoordinatorInterface

protocol TabItemCoordinatorInterface {
    var isEnabled: Bool { get }
    func didSelectTab(_ selectedTabIndex: Int,
                      previousTabIndex: Int)
}

class TabCoordinator: BaseCoordinator,
                      UITabBarControllerDelegate {
    private lazy var homeCoordinator = coordinatorBuilder.home
    private lazy var settingsCoordinator = coordinatorBuilder.settings
    private lazy var chatCoordinator = coordinatorBuilder.chat
    private var currentTabIndex = 0

    private var coordinators: [TabItemCoordinator] {
        [
            homeCoordinator,
            chatCoordinator,
            settingsCoordinator
        ].filter { $0.isEnabled }
    }

    private lazy var tabController = UITabBarController.govUK
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         analyticsService: AnalyticsServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
        tabController.delegate = self
    }

    override func start(url: URL?) {
        showTabsIfRequired()
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

        let isDeeplinkFound: Bool
        if let route = route {
            selectTabIndex(for: route.parent.root)
            route.action()
            isDeeplinkFound = true
        } else {
            presentDeeplinkNotFoundAlert()
            isDeeplinkFound = false
        }
        let event = AppEvent.deeplinkNavigation(
            isDeeplinkFound: isDeeplinkFound,
            url: url.absoluteString
        )
        analyticsService.track(event: event)
    }

    private func presentDeeplinkNotFoundAlert() {
        tabController.present(
            UIAlertController.deeplinkNotFoundAlert,
            animated: true
        )
    }

    private func showTabsIfRequired() {
        let viewControllers = tabController.viewControllers ?? []
        guard viewControllers.isEmpty else {
            return
        }

        tabController.viewControllers = coordinators.map { $0.root }
        set([tabController], animated: false)
        coordinators.forEach { start($0) }
    }

    private func selectTabIndex(for navigationController: UINavigationController) {
        let index = tabController.viewControllers?.firstIndex(of: navigationController)
        tabController.selectedIndex = index ?? 0
        currentTabIndex = tabController.selectedIndex
    }

    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        guard let title = viewController.tabBarItem.title else { return }
        let event = AppEvent.tabNavigation(text: title)
        analyticsService.track(event: event)
        coordinators[tabBarController.selectedIndex].didSelectTab(
            tabBarController.selectedIndex,
            previousTabIndex: currentTabIndex
        )
        currentTabIndex = tabBarController.selectedIndex
    }
}

import UIKit
import Foundation

class HomeCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    var searchActionButtonPressed: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let navigationController = UINavigationController()
            let coordinator = strongSelf.coordinatorBuilder.search(
                navigationController: navigationController
            )
            strongSelf.present(coordinator)
        }
    }

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.home(
            searchButtonPrimaryAction: searchActionButtonPressed
        )
        set([viewController], animated: false)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }
}

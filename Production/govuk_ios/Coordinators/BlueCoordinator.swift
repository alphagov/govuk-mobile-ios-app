import UIKit
import Foundation

class BlueCoordinator: BaseCoordinator,
                       DeeplinkRouteProvider {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.blue(
            showNextAction: startDriving
        )
        set([viewController], animated: false)
    }

    private var startDriving: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.driving(
                navigationController: self.root
            )
            self.start(coordinator)
        }
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }
}

protocol DeeplinkRouteProvider {
    func route(for: URL) -> ResolvedDeeplinkRoute?
}

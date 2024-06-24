import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start() {
        startLaunch()
    }

    private func startLaunch() {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] in
                self?.showTabs()
            }
        )
        start(coordinator)
    }

    private func showTabs() {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator)
    }
}

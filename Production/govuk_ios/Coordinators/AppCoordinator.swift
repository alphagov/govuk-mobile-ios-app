import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        startLaunch(url: url)
    }

    private func startLaunch(url: String?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] url in
                self?.showTabs(url: url)
            }
        )
        start(coordinator, url: url)
    }

    private func showTabs(url: String?) {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator, url: url)
    }
}

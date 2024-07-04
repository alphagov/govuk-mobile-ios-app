import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private var initialLaunch: Bool = true

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        if initialLaunch {
            startLaunch(url: url)
        } else {
            showTabs(url: url)
        }
    }

    private func startLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] in
                self?.showTabs(url: url)
                self?.initialLaunch = false
            }
        )
        start(coordinator)
    }

    private func showTabs(url: URL?) {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator, url: url)
    }
}

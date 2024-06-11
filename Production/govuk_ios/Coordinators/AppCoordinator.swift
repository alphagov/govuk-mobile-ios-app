import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let deeplinkService: DeeplinkServiceInterface
    private var firstLaunch: Bool = true

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         deeplinkService: DeeplinkServiceInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.deeplinkService = deeplinkService
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        if firstLaunch {
            startLaunch(url: url)
        } else {
            showTabs(url: url)
        }
    }

    private func startLaunch(url: String?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] url in
                self?.showTabs(url: url)
                self?.firstLaunch = false
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

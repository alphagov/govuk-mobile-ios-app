import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url:String?) {
        startLaunch(url:url)
    }

    private func startLaunch(url:String?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root, url: url,
            completion: { [weak self] in
                self?.showTabs(url:url)
            }
        )
        start(coordinator)
    }
    
    private func showTabs(url:String?) {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root, url: url
        )
        start(coordinator)
    }
}

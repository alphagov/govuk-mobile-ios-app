import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    override func start() {
        startLaunch()
    }

    private func startLaunch() {
        let coordinator = LaunchCoordinator(
            navigationController: root,
            completion: { [weak self] in
                self?.showTabs()
            }
        )
        start(coordinator)
    }

    private func showTabs() {
        let coordinator = TabCoordinator(
            navigationController: root
        )
        start(coordinator)
    }

    deinit {
        print("Deinit app")
    }
}

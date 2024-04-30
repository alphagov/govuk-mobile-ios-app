import UIKit

class AppCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabs()
    }

    private func showTabs() {
        let tabCoordinator = TabCoordinator(
            navigationController: navigationController
        )
        tabCoordinator.start()
    }

}

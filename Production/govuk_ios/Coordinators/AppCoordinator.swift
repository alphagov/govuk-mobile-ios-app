import UIKit

class AppCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(url: URL?) {
        showTabs(url: url)
    }

    private func showTabs(url: URL?) {
        let tabCoordinator = TabCoordinator(
            navigationController: navigationController
        )
        tabCoordinator.start(url: url)
    }

}

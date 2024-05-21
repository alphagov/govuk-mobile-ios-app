import UIKit

class AppCoordinator: BaseCoordinator {
    override func start() {
        showTabs()
    }

    private func showTabs() {
        let tabCoordinator = TabCoordinator(
            navigationController: root
        )
        push(tabCoordinator)
    }

    deinit {
        print("Deinit app")
    }
}

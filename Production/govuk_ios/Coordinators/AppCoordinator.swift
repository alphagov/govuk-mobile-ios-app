import UIKit

class AppCoordinator: Coordinator {
    override func start() {
        showTabs()
    }

    private func showTabs() {
        let tabCoordinator = TabCoordinator(
            navigationController: root
        )
        open(tabCoordinator)
    }

    deinit {
        print("Deinit app")
    }
}

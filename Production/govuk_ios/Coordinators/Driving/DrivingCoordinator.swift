import UIKit
import Foundation

class DrivingCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewController = TestViewController(
            color: .cyan,
            tabTitle: "Driving",
            nextAction: { [weak self] in
                self?.showPermit(permit: "123")
            },
            modalAction: { [weak self] in
                self?.presentPermit(permit: "123")
            }
        )
        push(viewController, animated: true)
    }

    private func showPermit(permit: String) {
        let coordinator = PermitCoordinator(
            navigationController: root
        )
        start(coordinator)
    }

    private func presentPermit(permit: String) {
        let coordinator = PermitCoordinator(
            navigationController: .init()
        )
        present(coordinator)
    }
}

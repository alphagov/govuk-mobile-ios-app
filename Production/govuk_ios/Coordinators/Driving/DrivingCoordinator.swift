import UIKit
import Foundation

class DrivingCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = TestViewModel(
            color: .cyan,
            tabTitle: "Driving",
            primaryTitle: "Push Permit",
            primaryAction: { [weak self] in
                self?.showPermit(permit: "123")
            },
            secondaryTitle: "Modal Permit",
            secondaryAction: { [weak self] in
                self?.presentPermit(permit: "123")
            }
        )
        let viewController = TestViewController(
            viewModel: viewModel
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

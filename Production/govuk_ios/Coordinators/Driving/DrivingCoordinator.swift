import UIKit
import Foundation

class DrivingCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: .cyan,
            tabTitle: "Driving",
            nextAction: { [weak self] in
                self?.showPermit(permit: "123")
            },
            modalAction: { [weak self] in
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

import UIKit
import Foundation

class PermitCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = TestViewModel(
            color: .lightGray,
            tabTitle: "Permit",
            primaryTitle: nil,
            primaryAction: nil,
            secondaryTitle: "Dismiss",
            secondaryAction: { [weak self] in
                self?.dismiss(animated: true)
                self?.finish()
            }
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        push(viewController, animated: true)
    }
}

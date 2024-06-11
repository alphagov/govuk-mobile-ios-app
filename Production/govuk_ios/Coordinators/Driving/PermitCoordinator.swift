import UIKit
import Foundation

class PermitCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: .lightGray,
            tabTitle: "Permit",
            nextAction: {},
            modalAction: { [weak self] in
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

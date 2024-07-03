import UIKit
import Foundation

class PermitCoordinator: BaseCoordinator {
    private let permitId: String

    init(permitId: String,
         navigationController: UINavigationController) {
        self.permitId = permitId
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewModel = TestViewModel(
            color: .lightGray,
            tabTitle: "Permit - \(permitId)",
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

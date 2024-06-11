import UIKit
import Foundation

class PermitCreateCoordinator: BaseCoordinator {
    init(navigationController: UINavigationController,
         created: @escaping (String) -> Void) {
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: .lightGray,
            tabTitle: "Create Permit",
            nextAction: {},
            modalAction: {}
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        push(viewController, animated: true)
    }
}

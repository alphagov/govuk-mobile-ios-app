import UIKit
import Foundation

class PermitCreateCoordinator: BaseCoordinator {
    init(navigationController: UINavigationController,
         created: @escaping (String) -> Void) {
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        let viewController = TestViewController(
            color: .lightGray,
            tabTitle: "Create Permit",
            nextAction: {},
            modalAction: {}
        )
        push(viewController, animated: true)
    }
}

import UIKit
import Foundation

class PermitCoordinator: BaseCoordinator {
    override func start(url: String?) {
        let viewController = TestViewController(
            color: .lightGray,
            tabTitle: "Permit",
            nextAction: {},
            modalAction: { [weak self] in
                self?.dismiss(animated: true)
                self?.finish()
            }
        )
        push(viewController, animated: true)
    }
}

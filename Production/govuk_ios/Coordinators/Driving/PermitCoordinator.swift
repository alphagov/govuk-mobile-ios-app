import UIKit
import Foundation

class PermitCoordinator: BaseCoordinator {
    private let permitId: String
    private let viewControllerBuilder: ViewControllerBuilder

    init(permitId: String,
         navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder) {
        self.permitId = permitId
        self.viewControllerBuilder = viewControllerBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.permit(
            permitId: permitId,
            finishAction: { [weak self] in
                self?.dismiss(animated: true)
                self?.finish()
            }
        )
        push(viewController, animated: true)
    }
}

import UIKit
import Foundation

class DrivingCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder) {
        self.viewControllerBuilder = viewControllerBuilder
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = viewControllerBuilder.driving(
            showPermitAction: { [weak self] in
                self?.showPermit(permit: "123")
            },
            presentPermitAction: { [weak self] in
                self?.presentPermit(permit: "123")
            }
        )
        push(viewController, animated: true)
    }

    private func showPermit(permit: String) {
        let coordinator = coordinatorBuilder.permit(
            navigationController: root
        )
        start(coordinator)
    }

    private func presentPermit(permit: String) {
        let coordinator = coordinatorBuilder.permit(
            navigationController: .init()
        )
        present(coordinator)
    }
}

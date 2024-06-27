import UIKit
import Foundation

class RedCoordinator: BaseCoordinator {
    private let coodinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder

    init(navigationController: UINavigationController,
         coodinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder) {
        self.coodinatorBuilder = coodinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = viewControllerBuilder.red(
            showNextAction: showNextAction,
            showModalAction: showModalAction
        )
        set([viewController], animated: false)
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let coordinator = strongSelf.coodinatorBuilder.next(
                title: "Next",
                navigationController: strongSelf.root
            )
            strongSelf.start(coordinator)
        }
    }

    private var showModalAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let navigationController = UINavigationController()
            let coordinator = strongSelf.coodinatorBuilder.next(
                title: "Modal",
                navigationController: navigationController
            )
            strongSelf.present(coordinator)
        }
    }
}

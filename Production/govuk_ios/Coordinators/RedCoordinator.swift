import UIKit
import Foundation

class RedCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = TestViewModel(
            color: .red,
            tabTitle: "Red",
            primaryTitle: "Next",
            primaryAction: showNextAction,
            secondaryTitle: "Modal",
            secondaryAction: showModalAction
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        set([viewController], animated: false)
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            guard let strongSelf = self else { return }
            let coordinator = NextCoordinator(
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
            let coordinator = NextCoordinator(
                title: "Modal",
                navigationController: navigationController
            )
            strongSelf.present(coordinator)
        }
    }
}

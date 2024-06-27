import UIKit
import Foundation

class ColorCoordinator: BaseCoordinator {
    private let color: UIColor
    private let title: String
    private let coordinatorBuilder: CoordinatorBuilder

    init(navigationController: UINavigationController,
         color: UIColor,
         title: String,
         coordinatorBuilder: CoordinatorBuilder) {
        self.color = color
        self.title = title
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewModel = TestViewModel(
            color: color,
            tabTitle: title,
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
            let coordinator = strongSelf.coordinatorBuilder.next(
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
            let coordinator = strongSelf.coordinatorBuilder.next(
                title: "Modal",
                navigationController: navigationController
            )
            strongSelf.present(coordinator)
        }
    }
}

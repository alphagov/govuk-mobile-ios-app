import UIKit
import Foundation

class BlueCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewModel = TestViewModel(
            color: .blue,
            tabTitle: "Blue",
            primaryTitle: "Next",
            primaryAction: showNextAction,
            secondaryTitle: nil,
            secondaryAction: nil
        )
        let viewController = TestViewController(
            viewModel: viewModel
        )
        set([viewController], animated: false)
    }

    private var showNextAction: () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            let coordinator = self.coordinatorBuilder.driving(
                navigationController: self.root
            )
            self.start(coordinator)
        }
    }
}

import UIKit
import Foundation

class ColorCoordinator: BaseCoordinator {
    private let color: UIColor
    private let title: String

    init(navigationController: UINavigationController,
         color: UIColor,
         title: String) {
        self.color = color
        self.title = title
        super.init(navigationController: navigationController)
    }

    override func start(url: String?) {
        let viewModel = TestViewModel(
            color: color,
            tabTitle: title,
            nextAction: showNextAction,
            modalAction: showModalAction
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

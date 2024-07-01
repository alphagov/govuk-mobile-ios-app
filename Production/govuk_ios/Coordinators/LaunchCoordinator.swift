import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewModel = LaunchViewModel(
            animationCompleted: { [weak self] in
                self?.completion()
            }
        )
        let viewController = LaunchViewController(
            viewModel: viewModel
        )
        set(viewController, animated: false)
    }
}

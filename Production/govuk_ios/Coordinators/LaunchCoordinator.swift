import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         completion: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = viewControllerBuilder.launch(
            completion: completion
        )
        set(viewController, animated: false)
    }
}

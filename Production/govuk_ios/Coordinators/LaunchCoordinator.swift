import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         appConfigService: AppConfigServiceInterface,
         completion: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.launch(
            completion: completion
        )
        set(viewController, animated: false)
    }
}

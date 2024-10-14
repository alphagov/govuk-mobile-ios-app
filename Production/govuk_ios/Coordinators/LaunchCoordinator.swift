import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let appConfigService: AppConfigServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         appConfigService: AppConfigServiceInterface,
         completion: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.appConfigService = appConfigService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        appConfigService.fetchAppConfig {
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        let viewController = viewControllerBuilder.launch(
            completion: { dispatchGroup.leave() }
        )
        set(viewController, animated: false)

        dispatchGroup.notify(queue: .main) {
            self.completion()
        }
    }
}

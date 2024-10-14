import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let appConfigService: AppConfigServiceInterface
    private let completion: () -> Void

    private let dispatchGroup = DispatchGroup()

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
        fetchAppConfig()

        setViewController()

        dispatchGroup.notify(queue: .main) {
            self.completion()
        }
    }

    private func fetchAppConfig() {
        dispatchGroup.enter()
        appConfigService.fetchAppConfig {
            self.dispatchGroup.leave()
        }
    }

    private func setViewController() {
        dispatchGroup.enter()
        let viewController = viewControllerBuilder.launch(
            completion: { self.dispatchGroup.leave() }
        )
        set(viewController, animated: false)
    }
}

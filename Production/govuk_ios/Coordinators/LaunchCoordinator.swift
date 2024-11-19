import UIKit
import Foundation

typealias LaunchCoordinatorCompletion = (sending AppLaunchResponse) -> Void
class LaunchCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let appLaunchService: AppLaunchServiceInterface
    private let completion: LaunchCoordinatorCompletion
    private var launchResponse: AppLaunchResponse?

    private let dispatchGroup = DispatchGroup()

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         appLaunchService: AppLaunchServiceInterface,
         completion: @escaping LaunchCoordinatorCompletion) {
        self.viewControllerBuilder = viewControllerBuilder
        self.appLaunchService = appLaunchService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        fetchLaunchResponse()
        setLaunchViewController()

        dispatchGroup.notify(
            queue: .main,
            execute: { [weak self] in
                self?.handleResponse()
            }
        )
    }

    private func handleResponse() {
        guard let launchResponse
        else { return }
        completion(launchResponse)
    }

    private func fetchLaunchResponse() {
        dispatchGroup.enter()
        appLaunchService.fetch(
            completion: { [weak self] response in
                self?.launchResponse = response
                self?.dispatchGroup.leave()
            }
        )
    }

    private func setLaunchViewController() {
        dispatchGroup.enter()
        let viewController = viewControllerBuilder.launch(
            completion: { [weak self] in
                self?.dispatchGroup.leave()
            }
        )
        set(viewController, animated: false)
    }
}

import UIKit
import Foundation

class LaunchCoordinator: BaseCoordinator {
    private let deeplinkService: DeeplinkServiceInterface
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         deeplinkService: DeeplinkServiceInterface,
         completion: @escaping () -> Void) {
        self.deeplinkService = deeplinkService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = LaunchViewController()
        set(viewController, animated: false)

        deeplinkService.handle(
            url: nil,
            completion: completion
        )
    }
}

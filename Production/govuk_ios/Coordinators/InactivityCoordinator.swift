import UIKit
import GOVKit

final class InactivityCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let inactivityService: InactivityServiceInterface
    private let inactiveAction: () -> Void

    init(navigationController: UINavigationController,
         inactivityService: InactivityServiceInterface,
         inactiveAction: @escaping () -> Void) {
        self.inactivityService = inactivityService
        self.inactiveAction = inactiveAction
        self.navigationController = navigationController
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        inactivityService.startMonitoring { [weak self] in
            self?.inactiveAction()
        }
    }
}

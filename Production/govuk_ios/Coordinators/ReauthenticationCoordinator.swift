import Foundation
import UIKit

class ReauthenticationCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let coordinatorBuilder: CoordinatorBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         authenticationService: AuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.navigationController = navigationController
        self.authenticationService = authenticationService
        self.completionAction = completionAction
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        Task {
            await reauthenticate()
        }
    }

    private func reauthenticate() async {
        guard authenticationService.shouldReauthenticate else {
            completionAction()
            return
        }
        let refreshRequestResult = await authenticationService.tokenRefreshRequest()

        switch refreshRequestResult {
        case .success:
            completionAction()
        case .failure:
            let coordinator = coordinatorBuilder.authenticationOnboarding(
                navigationController: navigationController,
                completionAction: completionAction
            )
            start(coordinator)
        }
    }
}

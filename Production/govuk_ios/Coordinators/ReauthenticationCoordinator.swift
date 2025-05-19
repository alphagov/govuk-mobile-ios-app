import Foundation
import UIKit

class ReauthenticationCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         completionAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
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
        guard localAuthenticationService.authenticationOnboardingFlowSeen else {
            completionAction()
            return
        }
        let refreshRequestResult = await authenticationService.tokenRefreshRequest()

        switch refreshRequestResult {
        case .success:
            completionAction()
        case .failure:
            let coordinator = coordinatorBuilder.authenticationOnboarding(
                navigationController: root,
                newUserAction: nil,
                completionAction: completionAction
            )
            start(coordinator)
        }
    }
}

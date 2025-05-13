import Foundation
import UIKit

class ReauthenticationCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let completionAction: () -> Void
    private let newUserAction: () -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         completionAction: @escaping () -> Void,
         newUserAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.completionAction = completionAction
        self.coordinatorBuilder = coordinatorBuilder
        self.newUserAction = newUserAction
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
        guard localAuthenticationService.biometricsHaveChanged == false else {
            authenticationService.signOut()
            handleReauthFailure()
            return
        }

        let refreshRequestResult = await authenticationService.tokenRefreshRequest()

        switch refreshRequestResult {
        case .success:
            completionAction()
        case .failure:
            self.handleReauthFailure()
            let coordinator = coordinatorBuilder.authenticationOnboarding(
                navigationController: root,
                newUserAction: newUserAction,
                completionAction: completionAction
            )
            start(coordinator)
        }
    }

    private func handleReauthFailure() {
        let coordinator = coordinatorBuilder.authenticationOnboarding(
            navigationController: root,
            completionAction: completionAction
        )
        start(coordinator)
    }
}

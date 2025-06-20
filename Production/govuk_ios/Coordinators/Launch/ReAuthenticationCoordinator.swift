import Foundation
import UIKit

class ReAuthenticationCoordinator: BaseCoordinator {
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
        guard localAuthenticationService.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics
        ).canEvaluate else {
            completionAction()
            return
        }
        guard !localAuthenticationService.biometricsHaveChanged else {
            handleReauthFailure()
            return
        }
        guard localAuthenticationService.availableAuthType == .faceID ||
                localAuthenticationService.touchIdEnabled else {
            handleReauthFailure()
            return
        }
        guard !localAuthenticationService.faceIdSkipped else {
            handleReauthFailure()
            return
        }

        let refreshRequestResult = await authenticationService.tokenRefreshRequest()

        switch refreshRequestResult {
        case .success:
            completionAction()
        case .failure:
            handleReauthFailure()
        }
    }

    private func handleReauthFailure() {
        authenticationService.signOut()
        let coordinator = coordinatorBuilder.welcomeOnboarding(
            navigationController: root,
            completionAction: completionAction
        )
        start(coordinator)
    }
}

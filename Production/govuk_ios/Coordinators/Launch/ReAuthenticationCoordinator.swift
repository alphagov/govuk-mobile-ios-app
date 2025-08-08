import Foundation
import UIKit
import GOVKit

class ReAuthenticationCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let completionAction: () -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         authenticationService: AuthenticationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         completionAction: @escaping () -> Void) {
        self.authenticationService = authenticationService
        self.localAuthenticationService = localAuthenticationService
        self.completionAction = completionAction
        self.coordinatorBuilder = coordinatorBuilder
        self.analyticsService = analyticsService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        guard authenticationService.shouldAttemptTokenRefresh
        else { return handleReauthFailure() }
        Task {
            await reauthenticate()
        }
    }

    private func reauthenticate() async {
        let policy = localAuthenticationService.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics
        )
        guard policy.canEvaluate else {
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
            analyticsService.setExistingConsent()
            completionAction()
        case .failure:
            handleReauthFailure()
        }
    }

    private func handleReauthFailure() {
        authenticationService.signOut(reason: .reauthFailure)
        let coordinator = coordinatorBuilder.welcomeOnboarding(
            navigationController: root,
            completionAction: completionAction
        )
        start(coordinator)
    }
}

import Foundation
import UIKit

class PeriAuthCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let authenticationService: AuthenticationServiceInterface
    private let completion: () -> Void

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         authenticationService: AuthenticationServiceInterface,
         completion: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.completion = completion
        self.authenticationService = authenticationService
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        startReauthentication(url: url)
    }

    private func startReauthentication(url: URL?) {
        guard authenticationService.shouldAttemptTokenRefresh
        else { return clearCurrentAuth(url: url) }

        let coordinator = coordinatorBuilder.reauthentication(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startWelcomeOnboarding(url: url)
            }
        )
        start(coordinator, url: url)
    }

    private func clearCurrentAuth(url: URL?) {
        authenticationService.clearTokens()
        startWelcomeOnboarding(url: url)
    }

    private func startWelcomeOnboarding(url: URL?) {
        let coordinator = coordinatorBuilder.welcomeOnboarding(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startLocalAuthenticationOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startLocalAuthenticationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.localAuthenticationOnboarding(
            navigationController: root,
            completionAction: { [weak self] in
                self?.completion()
            }
        )
        start(coordinator, url: url)
    }
}

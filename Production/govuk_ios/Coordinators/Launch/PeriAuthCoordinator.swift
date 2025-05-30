import Foundation
import UIKit

class PeriAuthCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let completion: () -> Void

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        startReauthentication(url: url)
    }

    private func startReauthentication(url: URL?) {
        let coordinator = coordinatorBuilder.reauthentication(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startAuthenticationOnboardingCoordinator(url: url)
            }
        )
        start(coordinator, url: url)
    }

    private func startAuthenticationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.authenticationOnboarding(
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
        start(coordinator)
    }
}

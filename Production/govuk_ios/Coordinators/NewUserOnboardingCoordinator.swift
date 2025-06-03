import UIKit
import Foundation

class NewUserOnboardingCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let completionAction: () -> Void

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         completionAction: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.completionAction = completionAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        startSignInSuccessCoordinator(url: url)
    }

    private func startSignInSuccessCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.signInSuccess(
            navigationController: root,
            completion: { [weak self] in
                self?.startLocalAuthenticationOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startLocalAuthenticationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.localAuthenticationOnboarding(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startAnalyticsConsent(url: url)
            }
        )
        start(coordinator)
    }

    private func startAnalyticsConsent(url: URL?) {
        let coordinator = coordinatorBuilder.analyticsConsent(
            navigationController: root,
            displayInModal: false,
            dismissAction: { [weak self] in
                self?.startTopicOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startTopicOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.topicOnboarding(
            navigationController: root,
            didDismissAction: { [weak self] in
                self?.startNotificationOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startNotificationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.notificationOnboarding(
            navigationController: root,
            completion: { [weak self] in
                self?.completionAction()
            }
        )
        start(coordinator)
    }
}

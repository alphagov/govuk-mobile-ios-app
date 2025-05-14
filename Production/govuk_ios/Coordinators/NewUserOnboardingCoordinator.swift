import UIKit
import Foundation

class NewUserOnboardingCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        startLocalAuthenticationOnboardingCoordinator(url: url)
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
            dismissAction: { [weak self] in
                self?.startOnboarding(url: url)
            }
        )
        start(coordinator)
    }

    private func startOnboarding(url: URL?) {
        let coordinator = coordinatorBuilder.onboarding(
            navigationController: root,
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
                self?.startTabs(url: url)
            }
        )
        start(coordinator)
    }

    private func startTabs(url: URL?) {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator, url: url)
    }
}

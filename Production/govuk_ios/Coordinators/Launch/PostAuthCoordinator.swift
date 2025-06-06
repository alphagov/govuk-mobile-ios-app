import Foundation
import UIKit

class PostAuthCoordinator: BaseCoordinator {
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
        startAnalyicsOnboardingCoordinator()
    }

    private func startAnalyicsOnboardingCoordinator() {
        let coordinator = coordinatorBuilder.analyticsConsent(
            navigationController: root,
            completion: { [weak self] in
                self?.startTopicOnboarding()
            }
        )
        start(coordinator)
    }

    private func startTopicOnboarding() {
        let coordinator = coordinatorBuilder.topicOnboarding(
            navigationController: root,
            didDismissAction: { [weak self] in
                self?.startNotificationOnboardingCoordinator()
            }
        )
        start(coordinator)
    }

    private func startNotificationOnboardingCoordinator() {
        let coordinator = coordinatorBuilder.notificationOnboarding(
            navigationController: root,
            completion: completion
        )
        start(coordinator)
    }
}

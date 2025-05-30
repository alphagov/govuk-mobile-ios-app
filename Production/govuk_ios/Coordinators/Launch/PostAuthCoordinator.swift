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
        startTopicOnboardingCoordinator(url: url)
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
            completion: completion
        )
        start(coordinator)
    }
}

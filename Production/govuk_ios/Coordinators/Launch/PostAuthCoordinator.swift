import Foundation
import UIKit

class PostAuthCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let completion: () -> Void
    private let remoteConfigService: RemoteConfigServiceInterface
    private(set) var remoteConfigActivationTask: Task<Void, Never>?

    init(coordinatorBuilder: CoordinatorBuilder,
         remoteConfigService: RemoteConfigServiceInterface,
         navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.remoteConfigService = remoteConfigService
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
                self?.activateRemoteConfig()
                // activate remote config after analytics consent to support a/b testing
            }
        )
        start(coordinator)
    }
    private func activateRemoteConfig() {
        remoteConfigActivationTask = Task {
            await remoteConfigService.activate()
            startTopicOnboarding()
        }
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
            completion: { [weak self] in
                self?.startChatOptInCoordinator()
            }
        )
        start(coordinator)
    }

    private func startChatOptInCoordinator() {
        let coordinator = coordinatorBuilder.chatOptIn(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startChatOffboardingCoordinator()
            }
        )
        start(coordinator)
    }

    private func startChatOffboardingCoordinator() {
        let coordinator = coordinatorBuilder.chatOffboarding(
            navigationController: root,
            completionAction: completion
        )
        start(coordinator)
    }
}

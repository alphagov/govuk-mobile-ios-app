import Foundation
import UIKit

class ReLaunchCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let notificationService: NotificationServiceInterface
    private let completion: () -> Void

    init(coordinatorBuilder: CoordinatorBuilder,
         notificationService: NotificationServiceInterface,
         navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.notificationService = notificationService
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        Task {
            let alignment = await notificationService.fetchConsentAlignment()
            startConsentCoordinator(
                result: alignment
            )
        }
    }

    @MainActor
    private func startConsentCoordinator(result: NotificationConsentResult) {
        let coordinator = coordinatorBuilder.notificationConsent(
            navigationController: root,
            consentResult: result,
            completion: completion
        )
        start(coordinator)
    }
}

import UIKit
import Foundation
import GOVKit

class NotificationSettingsCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let notificationService: NotificationServiceInterface
    private let completeAction: () -> Void
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         notificationService: NotificationServiceInterface,
         completeAction: @escaping () -> Void,
         dismissAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.notificationService = notificationService
        self.completeAction = completeAction
        self.dismissAction = dismissAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.notificationSettings(
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                self?.requestPermission()
            },
            dismissAction: dismissAction
        )
        push(viewController, animated: true)
    }

    private func requestPermission() {
        notificationService.requestPermissions(
            completion: completeAction
        )
    }
}

import UIKit
import Foundation
import GOVKit

class NotificationSettingsCoordinator: BaseCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let analyticsService: AnalyticsServiceInterface
    private let notificationService: NotificationServiceInterface
    private let completeAction: () -> Void


    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         analyticsService: AnalyticsServiceInterface,
         notificationService: NotificationServiceInterface,
         completeAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.analyticsService = analyticsService
        self.notificationService = notificationService
        self.completeAction = completeAction
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.notificationSettings(
            analyticsService: analyticsService,
            notificationService: notificationService,
            completeAction: completeAction
        )
        push(viewController, animated: true)
    }
}

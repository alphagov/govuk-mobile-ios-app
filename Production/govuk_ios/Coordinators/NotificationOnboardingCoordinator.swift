import Foundation
import UIKit
import GOVKit
import UIComponents
import Onboarding

class NotificationOnboardingCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let notificationOnboardingService: NotificationsOnboardingServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         notificationOnboardingService: NotificationsOnboardingServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.notificationOnboardingService = notificationOnboardingService
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.completeAction = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        Task {
            await startNotifications()
        }
    }

    private func startNotifications() async {
        guard await notificationService.shouldRequestPermission,
              !notificationOnboardingService.hasSeenNotificationsOnboarding else {
            return finishCoordination()
        }
        setOnboarding()
    }

    private func setOnboarding() {
        let viewController = viewControllerBuilder.notificationOnboarding(
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                self?.request()
            },
            dismissAction: { [weak self] in
                self?.finishCoordination()
            }
        )
        set(viewController)
    }

    private func request() {
        notificationService.requestPermissions(
            completion: { [weak self] in
                self?.finishCoordination()
            }
        )
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.notificationOnboardingService.setHasSeenNotificationsOnboarding()
            self.completeAction()
        }
    }
}

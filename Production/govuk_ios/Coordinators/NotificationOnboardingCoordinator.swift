import Foundation
import UIKit
import GOVKit
import UIComponents
import Onboarding

class NotificationOnboardingCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let notificationService: NotificationServiceInterface
    private let notificationOnboardingService: NotificationsOnboardingServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let viewControllerBuilder: ViewControllerBuilder
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         notificationService: NotificationServiceInterface,
         notificationOnboardingService: NotificationsOnboardingServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.coordinatorBuilder = coordinatorBuilder
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
            openAction: { [weak self] url in
                self?.presentWebView(url: url)
            },
            completeAction: { [weak self] in
                self?.request()
            },
            dismissAction: { [weak self] in
                self?.finishCoordination()
            }
        )
        set(viewController)
    }

    private func presentWebView(url: URL) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: false
        )
        start(coordinator, url: url)
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

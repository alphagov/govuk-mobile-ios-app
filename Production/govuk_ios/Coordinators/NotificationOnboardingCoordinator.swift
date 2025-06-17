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
    private let coordinatorBuilder: CoordinatorBuilder
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         notificationOnboardingService: NotificationsOnboardingServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         viewControllerBuilder: ViewControllerBuilder,
         coordinatorBuilder: CoordinatorBuilder,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.notificationOnboardingService = notificationOnboardingService
        self.analyticsService = analyticsService
        self.viewControllerBuilder = viewControllerBuilder
        self.coordinatorBuilder = coordinatorBuilder
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
            },
            viewPrivacyAction: { [weak self] in
                self?.openPrivacy()
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

    @MainActor
    private func openPrivacy() {
        let coordinator = coordinatorBuilder.safari(
            presentingViewController: root.presentedViewController ?? root,
            url: Constants.API.privacyPolicyUrl,
            fullScreen: false
        )
        start(coordinator)
    }

    @MainActor
    private func finishCoordination() {
        notificationOnboardingService.setHasSeenNotificationsOnboarding()
        completeAction()
    }
}

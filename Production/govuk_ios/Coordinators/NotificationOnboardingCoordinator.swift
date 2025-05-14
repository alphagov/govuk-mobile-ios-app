import Foundation
import UIKit
import GOVKit
import UIComponents
import Onboarding

class NotificationOnboardingCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let analyticsService: OnboardingAnalyticsService
    private let completeAction: () -> Void
    private let userDefaults: UserDefaultsInterface

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         analyticsService: OnboardingAnalyticsService,
         userDefaults: UserDefaultsInterface = UserDefaults.standard,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.analyticsService = analyticsService
        self.userDefaults = userDefaults
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
              !userDefaults.isNotificationsOnboardingSeen()
        else {
            return finishCoordination()
        }
        setOnboarding()
    }

    private func setOnboarding() {
        let onboardingModule = Onboarding(
            slideProvider: notificationService,
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                self?.request()
            },
            dismissAction: { [weak self] in
                self?.finishCoordination()
            }
        )
        set(onboardingModule.viewController)
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
            self.userDefaults.setNotificationsOnboardingSeen()
            self.completeAction()
        }
    }
}

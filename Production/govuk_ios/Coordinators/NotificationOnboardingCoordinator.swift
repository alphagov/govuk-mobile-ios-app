import Foundation
import UIKit
import GOVKit
import UIComponents
import Onboarding

class NotificationOnboardingCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let analyticsService: OnboardingAnalyticsService
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         analyticsService: OnboardingAnalyticsService,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.analyticsService = analyticsService
        self.completeAction = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        Task {
            await startNotifications()
        }
    }

    private func startNotifications() async {
        guard await notificationService.shouldRequestPermission
        else { return finishCoordination() }
        setOnboarding()
    }

    private func pushNotification() {
        let primaryViewModel = GOVUKButton.ButtonViewModel(
            localisedTitle: String.notifications.localized("onboardingAcceptButtonTitle"),
            action: { self.request() }
        )
        let secondaryViewModel = GOVUKButton.ButtonViewModel(
            localisedTitle: String.notifications.localized("onboardingSkipButtonTitle"),
            action: { self.finishCoordination() }
        )
        let viewModel = NotificationOnboardingViewModel(
            animationName: "onboarding_stay_updated",
            primaryButtonViewModel: primaryViewModel,
            secondaryButtonViewModel: secondaryViewModel
        )
        let view = OnboardingView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
        root.setViewControllers(
            [viewController],
            animated: true
        )
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
            self.completeAction()
        }
    }
}

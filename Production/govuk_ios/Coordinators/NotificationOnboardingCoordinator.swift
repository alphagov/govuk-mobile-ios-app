import Foundation
import UIKit
import GOVKit
import UIComponents
import Onboarding

class NotificationOnboardingCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let completeAction: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
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

    private func setOnboarding() {
        let viewModel = NotificationsOnboardingViewModel(
            urlOpener: UIApplication.shared,
            analyticsService: analyticsService,
            completeAction: { [weak self] in
                self?.request()
            }, dismissAction: { [weak self] in
                self?.finishCoordination()
            }
        )
        let view = NotificationsOnboardingView(viewModel: viewModel)
        let viewController = HostingViewController(rootView: view)
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
            self.completeAction()
        }
    }
}

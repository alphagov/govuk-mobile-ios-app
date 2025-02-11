import Foundation
import UIKit
import GOVKit
import UIComponents

class NotificationOnboardingCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let complete: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         complete: @escaping () -> Void) {
        self.notificationService = notificationService
        self.complete = complete
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
        pushNotification()
    }

    private func pushNotification() {
        let primaryViewModel = GOVUKButton.ButtonViewModel(
            localisedTitle: "Accept",
            action: { self.request() }
        )
        let secondaryViewModel = GOVUKButton.ButtonViewModel(
            localisedTitle: "Skip",
            action: { self.finishCoordination() }
        )
        let viewModel = NotificationOnboardingViewModel(
            animationName: "onboarding_stay_updated",
            title: "Notifications",
            body: "Want some?",
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

    private func request() {
        notificationService.requestPermissions(
            completion: complete
        )
    }

    private func finishCoordination() {
        DispatchQueue.main.async {
            self.complete()
        }
    }
}

struct NotificationOnboardingViewModel: OnboardingViewModel {
    var animationName: String
    var title: String
    var body: String
    var primaryButtonViewModel: GOVUKButton.ButtonViewModel
    var secondaryButtonViewModel: GOVUKButton.ButtonViewModel
}

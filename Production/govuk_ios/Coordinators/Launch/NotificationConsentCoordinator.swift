import Foundation
import UIKit
import GOVKit

@MainActor
class NotificationConsentCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let consentResult: NotificationConsentResult
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let urlOpener: URLOpener
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         consentResult: NotificationConsentResult,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         urlOpener: URLOpener,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.analyticsService = analyticsService
        self.consentResult = consentResult
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.urlOpener = urlOpener
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        switch consentResult {
        case .aligned:
            dismissConsentViewControllerIfRequired()
            finishAction()
        case .misaligned(.consentGrantedNotificationsOff):
            notificationService.rejectConsent()
            dismissConsentViewControllerIfRequired()
            finishAction()
        case .misaligned(.consentNotGrantedNotificationsOn):
            presentConsentViewController()
        }
    }

    private func presentConsentViewController() {
        guard !isPresentingConsentAlert else { return }
        root.dismiss(animated: true)
        let viewController = viewControllerBuilder.notificationConsentAlert(
            analyticsService: analyticsService,
            viewPrivacyAction: { [weak self] in
                self?.openPrivacy()
            },
            grantConsentAction: { [weak self] in
                self?.notificationService.acceptConsent()
                self?.root.dismiss(
                    animated: true,
                    completion: self?.completion
                )
            },
            openSettingsAction: { [weak self] viewController in
                self?.presentSettingsAlert(viewController: viewController)
            }
        )
        root.present(viewController, animated: true)
    }

    private func presentSettingsAlert(viewController: UIViewController) {
        let alert = UIAlertController(
            title: String.notifications.localized("consentAlertSettingsAlertTitle"),
            message: String.notifications.localized("consentAlertSettingsAlertBody"),
            preferredStyle: .alert
        )
        alert.addAction(.cancel(handler: nil))
        alert.addAction(
            .continueAction(
                handler: { [weak self] in
                    self?.openSettings()
                }
            )
        )
        viewController.present(alert, animated: true)
    }

    private func dismissConsentViewControllerIfRequired() {
        guard isPresentingConsentAlert
        else { return }

        root.dismiss(animated: false)
    }

    private var isPresentingConsentAlert: Bool {
        let presentedNavigationController = root.presentedViewController as? UINavigationController
        let presentedViewController = presentedNavigationController?.topViewController ??
        root.presentedViewController
        return presentedViewController is NotificationConsentAlertViewController
    }

    private func openPrivacy() {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: Constants.API.privacyPolicyUrl,
            fullScreen: false
        )
        start(coordinator)
    }

    private func openSettings() {
        urlOpener.openNotificationSettings()
    }

    private func acceptConsent() {
        notificationService.acceptConsent()
    }

    @MainActor
    private func finishAction() {
        completion()
    }
}

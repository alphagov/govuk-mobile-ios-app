import Foundation
import UIKit
import GOVKit

class NotificationConsentCoordinator: BaseCoordinator {
    private let notificationService: NotificationServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let consentResult: NotificationConsentResult
    private let urlOpener: URLOpener
    private let completion: () -> Void

    init(navigationController: UINavigationController,
         notificationService: NotificationServiceInterface,
         analyticsService: AnalyticsServiceInterface,
         consentResult: NotificationConsentResult,
         urlOpener: URLOpener,
         completion: @escaping () -> Void) {
        self.notificationService = notificationService
        self.analyticsService = analyticsService
        self.consentResult = consentResult
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

    @MainActor
    private func presentConsentViewController() {
        guard !isPresentingConsentAlert else { return }
        root.dismiss(animated: true)
        let viewController = NotificationConsentAlertViewController(
            analyticsService: analyticsService
        )
        viewController.grantConsentAction = { [weak self] in
            self?.notificationService.acceptConsent()
            self?.root.dismiss(
                animated: true,
                completion: self?.completion
            )
        }
        viewController.openSettingsAction = { [weak self] in
            self?.openSettings()
        }
        root.present(viewController, animated: true)
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

import UIKit
import Foundation

class PreAuthCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let completion: () -> Void

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController,
         completion: @escaping () -> Void) {
        self.coordinatorBuilder = coordinatorBuilder
        self.completion = completion
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        startJailbreakDetection(url: url)
    }

    private func startLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] response in
                self?.startAnalyticsConsent(
                    url: url,
                    launchResponse: response
                )
            }
        )
        start(coordinator)
    }

    private func startJailbreakDetection(url: URL?) {
        let coordinator = coordinatorBuilder.jailbreakDetector(
            navigationController: root,
            dismissAction: { [weak self] in
                self?.startLaunch(
                    url: url
                )
            }
        )
        start(coordinator)
    }

    private func startAnalyticsConsent(url: URL?,
                                       launchResponse: AppLaunchResponse) {
        let coordinator = coordinatorBuilder.analyticsConsent(
            navigationController: root,
            completion: { [weak self] in
                self?.startNotificationConsentCheck(
                    url: url,
                    launchResponse: launchResponse
                )
            }
        )
        start(coordinator)
    }

    private func startNotificationConsentCheck(url: URL?,
                                               launchResponse: AppLaunchResponse) {
        let coordinator = coordinatorBuilder.notificationConsent(
            navigationController: root,
            consentResult: launchResponse.notificationConsentResult,
            completion: { [weak self] in
                self?.startAppForcedUpdate(
                    url: url,
                    launchResponse: launchResponse
                )
            }
        )
        start(coordinator)
    }

    private func startAppForcedUpdate(url: URL?,
                                      launchResponse: AppLaunchResponse) {
        let coordinator = coordinatorBuilder.appForcedUpdate(
            navigationController: root,
            launchResponse: launchResponse,
            dismissAction: { [weak self] in
                self?.startAppUnavailable(
                    url: url,
                    launchResponse: launchResponse
                )
            }
        )
        start(coordinator)
    }

    private func startAppUnavailable(url: URL?,
                                     launchResponse: AppLaunchResponse) {
        let coordinator = coordinatorBuilder.appUnavailable(
            navigationController: root,
            launchResponse: launchResponse,
            dismissAction: { [weak self] in
                self?.startAppRecommendUpdate(
                    url: url,
                    launchResponse: launchResponse
                )
            }
        )
        start(coordinator)
    }

    private func startAppRecommendUpdate(url: URL?,
                                         launchResponse: AppLaunchResponse) {
        let coordinator = coordinatorBuilder.appRecommendUpdate(
            navigationController: root,
            launchResponse: launchResponse,
            dismissAction: { [weak self] in
                self?.completion()
            }
        )
        start(coordinator)
    }
}

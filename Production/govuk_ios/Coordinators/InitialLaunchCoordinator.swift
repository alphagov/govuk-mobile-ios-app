import UIKit
import Foundation

class InitialLaunchCoordinator: BaseCoordinator {
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
        startLaunch(url: url)
    }

    private func startLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] response in
                self?.startConsentCheck(
                    url: url,
                    launchResponse: response
                )
            }
        )
        start(coordinator)
    }

    private func startConsentCheck(url: URL?,
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
                self?.startAnalyticsConsent(url: url)
            }
        )
        start(coordinator)
    }

    private func startAnalyticsConsent(url: URL?) {
        let coordinator = coordinatorBuilder.analyticsConsent(
            navigationController: root,
            dismissAction: { [weak self] in
                self?.startOnboarding(url: url)
            }
        )
        start(coordinator)
    }

    private func startOnboarding(url: URL?) {
        let coordinator = coordinatorBuilder.onboarding(
            navigationController: root,
            dismissAction: { [weak self] in
                self?.startReauthentication(url: url)
            }
        )
        start(coordinator)
    }

    private func startReauthentication(url: URL?) {
        let coordinator = coordinatorBuilder.reauthentication(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startAuthenticationOnboardingCoordinator(url: url)
            },
            newUserAction: { }
        )
        start(coordinator, url: url)
    }

    private func startAuthenticationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.authenticationOnboarding(
            navigationController: root,
            newUserAction: { },
            completionAction: { [weak self] in
                self?.startLocalAuthenticationOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startLocalAuthenticationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.localAuthenticationOnboarding(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startTopicOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startTopicOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.topicOnboarding(
            navigationController: root,
            didDismissAction: { [weak self] in
                self?.startNotificationOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startNotificationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.notificationOnboarding(
            navigationController: root,
            completion: completion
        )
        start(coordinator)
    }
}

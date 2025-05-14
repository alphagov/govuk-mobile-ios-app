import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private var initialLaunch: Bool = true
    private lazy var tabCooordinator: BaseCoordinator = {
        coordinatorBuilder.tab(
            navigationController: root
        )
    }()

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        if initialLaunch {
            firstLaunch(url: url)
        } else {
            reLaunch(url: url)
        }
    }

    private func firstLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] response in
                self?.initialLaunch = false
                self?.startConsentCheck(
                    url: url,
                    launchResponse: response
                )
            }
        )
        start(coordinator)
    }

    private func reLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.relaunch(
            navigationController: root,
            completion: { [weak self] in
                self?.startTabs(url: url)
            }
        )
        start(coordinator, url: url)
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
                self?.startReauthentication(url: url)
            }
        )
        start(coordinator)
    }

    private func startReauthentication(url: URL?) {
        let coordinator = coordinatorBuilder.reauthentication(
            navigationController: root,
            completionAction: { [weak self] in
                self?.startAnalyticsConsent(url: url)
            }
        )
        start(coordinator, url: url)
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
                self?.startAuthenticationOnboardingCoordinator(url: url)
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

    private func startAuthenticationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.authenticationOnboarding(
            navigationController: root,
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

    private func startNotificationOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.notificationOnboarding(
            navigationController: root,
            completion: { [weak self] in
                self?.startTabs(url: url)
            }
        )
        start(coordinator)
    }

    private func startSignedOutCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.signedOut(
            navigationController: root,
            completion: { [weak self] signedIn in
                if signedIn {
                    self?.startTabs(
                        url: URL(string: "govuk://settings/settings")
                    )
                } else {
                    self?.startAuthenticationOnboardingCoordinator(url: nil)
                }
            }
        )
        start(coordinator, url: url)
    }

    private func startTabs(url: URL?) {
        start(tabCooordinator, url: url)
    }

    override func childDidFinish(_ child: BaseCoordinator) {
        super.childDidFinish(child)
        if child is TabCoordinator {
            startSignedOutCoordinator(url: nil)
        }
    }
}

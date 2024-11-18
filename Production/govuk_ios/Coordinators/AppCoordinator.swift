import UIKit
import Foundation

class AppCoordinator: BaseCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private var initialLaunch: Bool = true

    init(coordinatorBuilder: CoordinatorBuilder,
         navigationController: UINavigationController) {
        self.coordinatorBuilder = coordinatorBuilder
        super.init(navigationController: navigationController)
    }

    override func start(url: URL?) {
        if initialLaunch {
            startLaunch(url: url)
        } else {
            startTabs(url: url)
        }
    }

    private func startLaunch(url: URL?) {
        let coordinator = coordinatorBuilder.launch(
            navigationController: root,
            completion: { [weak self] response in
                self?.initialLaunch = false
                self?.startAppUnavailable(
                    url: url,
                    launchResponse: response
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
                self?.startAppForcedUpdate(url: url)
            }
        )
        start(coordinator)
    }

    private func startTopicOnboardingCoordinator(url: URL?) {
        let coordinator = coordinatorBuilder.topicOnboarding(
            navigationController: root,
            didDismissAction: { [weak self] in
                self?.startTabs(url: url)
            }
        )
        start(coordinator)
    }

    private func startAppForcedUpdate(url: URL?) {
        let coordinator = coordinatorBuilder.appForcedUpdate(
            navigationController: root,
            dismissAction: { [weak self] in
                self?.startAppRecommendUpdate(url: url)
            }
        )
        start(coordinator)
    }

    private func startAppRecommendUpdate(url: URL?) {
        let coordinator = coordinatorBuilder.appRecommendUpdate(
            navigationController: root,
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
                self?.startTopicOnboardingCoordinator(url: url)
            }
        )
        start(coordinator)
    }

    private func startTabs(url: URL?) {
        let coordinator = coordinatorBuilder.tab(
            navigationController: root
        )
        start(coordinator, url: url)
    }
}

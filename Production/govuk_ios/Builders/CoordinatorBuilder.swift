import UIKit
import Foundation
import Factory

@MainActor
class CoordinatorBuilder {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

    func app(navigationController: UINavigationController) -> BaseCoordinator {
        AppCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController
        )
    }

    var home: TabItemCoordinator {
        let navigationController = UINavigationController.home

        return HomeCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: DeeplinkDataStore.home(
                coordinatorBuilder: self,
                root: navigationController
            ),
            analyticsService: container.analyticsService.resolve(),
            configService: container.appConfigService.resolve(),
            topicsService: container.topicsService.resolve(),
            notificationService: container.notificationService.resolve(),
            deviceInformationProvider: DeviceInformationProvider(),
            searchService: container.searchService.resolve(),
            activityService: container.activityService.resolve(),
            localAuthorityService: container.localAuthorityService.resolve()
        )
    }

    var settings: TabItemCoordinator {
        let navigationController = UINavigationController.settings

        return SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: DeeplinkDataStore.settings(
                coordinatorBuilder: self,
                root: navigationController
            ),
            analyticsService: container.analyticsService.resolve(),
            coordinatorBuilder: self,
            deviceInformationProvider: DeviceInformationProvider(),
            authenticationService: container.authenticationService.resolve(),
            notificationService: container.notificationService.resolve()
        )
    }

    func launch(navigationController: UINavigationController,
                completion: @escaping (AppLaunchResponse) -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            appLaunchService: container.appLaunchService.resolve(),
            anayticsService: container.analyticsService.resolve(),
            completion: completion
        )
    }

    func appUnavailable(navigationController: UINavigationController,
                        launchResponse: AppLaunchResponse,
                        dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AppUnavailableCoordinator(
            navigationController: navigationController,
            appLaunchService: container.appLaunchService.resolve(),
            launchResponse: launchResponse,
            dismissAction: dismissAction
        )
    }

    func appRecommendUpdate(navigationController: UINavigationController,
                            launchResponse: AppLaunchResponse,
                            dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AppRecommendUpdateCoordinator(
            navigationController: navigationController,
            launchResponse: launchResponse,
            dismissAction: dismissAction
        )
    }

    func appForcedUpdate(navigationController: UINavigationController,
                         launchResponse: AppLaunchResponse,
                         dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AppForcedUpdateCoordinator(
            navigationController: navigationController,
            launchResponse: launchResponse,
            dismissAction: dismissAction
        )
    }

    func analyticsConsent(navigationController: UINavigationController,
                          dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AnalyticsConsentCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            dismissAction: dismissAction
        )
    }

    func tab(navigationController: UINavigationController) -> BaseCoordinator {
        TabCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController,
            analyticsService: container.analyticsService()
        )
    }

    func onboarding(navigationController: UINavigationController,
                    dismissAction: @escaping () -> Void) -> BaseCoordinator {
        OnboardingCoordinator(
            navigationController: navigationController,
            onboardingService: container.onboardingService.resolve(),
            analyticsService: container.onboardingAnalyticsService.resolve(),
            appConfigService: container.appConfigService.resolve(),
            dismissAction: dismissAction
        )
    }

    func recentActivity(navigationController: UINavigationController) -> BaseCoordinator {
        RecentActivityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            activityService: container.activityService.resolve()
        )
    }

    func topicDetail(_ topic: Topic,
                     navigationController: UINavigationController) -> BaseCoordinator {
        TopicDetailsCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            topicsService: container.topicsService.resolve(),
            activityService: container.activityService.resolve(),
            viewControllerBuilder: ViewControllerBuilder(),
            topic: topic
        )
    }

    func editTopics(navigationController: UINavigationController,
                    didDismissAction: @escaping () -> Void) -> BaseCoordinator {
        EditTopicsCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            topicsService: container.topicsService.resolve(),
            viewControllerBuilder: ViewControllerBuilder(),
            dismissed: didDismissAction
        )
    }

    func allTopics(navigationController: UINavigationController) -> BaseCoordinator {
        AllTopicsCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            viewControllerBuilder: ViewControllerBuilder(),
            coordinatorBuilder: self,
            topicsService: container.topicsService.resolve()
        )
    }

    func localAuthority(navigationController: UINavigationController,
                        dismissAction: @escaping () -> Void) -> BaseCoordinator {
        LocalAuthorityServiceCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            localAuthorityService: container.localAuthorityService.resolve(),
            coordinatorBuilder: self,
            dismissed: dismissAction
        )
    }

    func topicOnboarding(navigationController: UINavigationController,
                         didDismissAction: @escaping () -> Void) -> BaseCoordinator {
        TopicOnboardingCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            topicsService: container.topicsService.resolve(),
            configService: container.appConfigService.resolve(),
            dismissAction: didDismissAction
        )
    }

    func notificationOnboarding(navigationController: UINavigationController,
                                completion: @escaping () -> Void) -> BaseCoordinator {
        NotificationOnboardingCoordinator(
            navigationController: navigationController,
            notificationService: container.notificationService.resolve(),
            analyticsService: container.onboardingAnalyticsService.resolve(),
            completion: completion
        )
    }

    func notificationSettings(navigationController: UINavigationController,
                              completionAction: @escaping () -> Void) -> BaseCoordinator {
        NotificationSettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            notificationService: container.notificationService.resolve(),
            completeAction: completionAction
        )
    }

    func authenticationOnboarding(navigationController: UINavigationController,
                                  completionAction: @escaping () -> Void) -> BaseCoordinator {
        AuthenticationOnboardingCoordinator(
            navigationController: navigationController,
            analyticsService: container.onboardingAnalyticsService.resolve(),
            authenticationOnboardingService: container.authenticationOnboardingService.resolve(),
            coordinatorBuilder: self,
            completionAction: completionAction
        )
    }

    func authentication(navigationController: UINavigationController,
                        completionAction: @escaping () -> Void) -> BaseCoordinator {
        AuthenticationCoordinator(
            navigationController: navigationController,
            authenticationService: container.authenticationService.resolve(),
            completionAction: completionAction
        )
    }

    func localAuthenticationOnboarding(navigationController: UINavigationController,
                                       completionAction: @escaping () -> Void) -> BaseCoordinator {
        LocalAuthenticationOnboardingCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            localAuthenticationService: container.localAuthenticationService.resolve(),
            authenticationService: container.authenticationService.resolve(),
            completionAction: completionAction
        )
    }

    func signOutConfirmation() -> BaseCoordinator {
        SignOutConfirmationCoordinator(
            navigationController: UINavigationController(),
            viewControllerBuilder: ViewControllerBuilder(),
            authenticationService: container.authenticationService.resolve(),
            analyticsService: container.analyticsService.resolve()
        )
    }

    func signedOut(navigationController: UINavigationController,
                   completion: @escaping () -> Void) -> BaseCoordinator {
        SignedOutCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            authenticationService: container.authenticationService.resolve(),
            analyticsService: container.analyticsService.resolve(),
            completion: completion
        )
    }

    func webView(url: URL) -> BaseCoordinator {
        WebViewCoordinator(
            navigationController: UINavigationController(),
            viewControllerBuilder: ViewControllerBuilder(),
            url: url
        )
    }
}

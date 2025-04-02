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
        HomeCoordinator(
            navigationController: UINavigationController.home,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: DeeplinkDataStore.home(coordinatorBuilder: self),
            analyticsService: container.analyticsService.resolve(),
            configService: container.appConfigService.resolve(),
            topicsService: container.topicsService.resolve(),
            notificationService: container.notificationService.resolve(),
            deviceInformationProvider: DeviceInformationProvider(),
            searchService: container.searchService.resolve(),
            activityService: container.activityService.resolve()
        )
    }

    var settings: TabItemCoordinator {
        SettingsCoordinator(
            navigationController: UINavigationController.settings,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: DeeplinkDataStore.settings(coordinatorBuilder: self),
            analyticsService: container.analyticsService.resolve(),
            coordinatorBuilder: self,
            deviceInformationProvider: DeviceInformationProvider(),
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
}

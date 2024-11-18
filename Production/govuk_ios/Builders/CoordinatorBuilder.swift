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
            navigationController: .home,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .home(coordinatorBuilder: self),
            analyticsService: container.analyticsService.resolve(),
            configService: container.appConfigService.resolve(),
            topicsService: container.topicsService.resolve()
        )
    }

    var settings: TabItemCoordinator {
        SettingsCoordinator(
            navigationController: .settings,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deeplinkStore: .settings(coordinatorBuilder: self),
            analyticsService: container.analyticsService.resolve()
        )
    }

    func launch(navigationController: UINavigationController,
                completion: @escaping (AppLaunchResponse) -> Void) -> BaseCoordinator {
        LaunchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            appLaunchService: container.appLaunchService.resolve(),
            completion: completion
        )
    }

    func appUnavailable(navigationController: UINavigationController,
                        launchResponse: AppLaunchResponse,
                        dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AppUnavailableCoordinator(
            navigationController: navigationController,
            appConfigService: container.appConfigService.resolve(),
            launchResponse: launchResponse,
            dismissAction: dismissAction
        )
    }

    func appRecommendUpdate(navigationController: UINavigationController,
                            dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AppRecommendUpdateCoordinator(
            navigationController: navigationController,
            appConfigService: container.appConfigService.resolve(),
            dismissAction: dismissAction
        )
    }

    func appForcedUpdate(navigationController: UINavigationController,
                         dismissAction: @escaping () -> Void) -> BaseCoordinator {
        AppForcedUpdateCoordinator(
            navigationController: navigationController,
            appConfigService: container.appConfigService.resolve(),
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

    func search(navigationController: UINavigationController,
                didDismissAction: @escaping () -> Void) -> BaseCoordinator {
        SearchCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            searchService: container.searchService.resolve(),
            dismissed: didDismissAction
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
            dismissAction: didDismissAction
        )
    }
}

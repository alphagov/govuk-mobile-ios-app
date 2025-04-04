import UIKit
import Foundation
import Factory

@testable import govuk_ios

extension CoordinatorBuilder {
    static var mock: MockCoordinatorBuilder {
        MockCoordinatorBuilder(container: Container())
    }
}

class MockCoordinatorBuilder: CoordinatorBuilder {

    var _stubbedTabCoordinator: MockBaseCoordinator?
    var _receivedTabNavigationController: UINavigationController?
    override func tab(navigationController: UINavigationController) -> BaseCoordinator {
        _receivedTabNavigationController = navigationController
        return _stubbedTabCoordinator ??
        MockBaseCoordinator(
            navigationController: navigationController
        )
    }

    var _stubbedLaunchCoordinator: MockBaseCoordinator?
    var _receivedLaunchNavigationController: UINavigationController?
    var _receivedLaunchCompletion: LaunchCoordinatorCompletion?
    override func launch(navigationController: UINavigationController,
                         completion: @escaping LaunchCoordinatorCompletion) -> BaseCoordinator {
        _receivedLaunchNavigationController = navigationController
        _receivedLaunchCompletion = completion
        return _stubbedLaunchCoordinator ??
        MockBaseCoordinator(
            navigationController: navigationController
        )
    }

    var _stubbedHomeCoordinator: TabItemCoordinator?
    override var home: any TabItemCoordinator {
        _stubbedHomeCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedSettingsCoordinator: TabItemCoordinator?
    override var settings: any TabItemCoordinator {
        return _stubbedSettingsCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedAnalyticsConsentCoordinator: BaseCoordinator?
    var _receivedAnalyticsConsentNavigationController: UINavigationController?
    var _receivedAnalyticsConsentDismissAction: (() -> Void)?

    override func analyticsConsent(navigationController: UINavigationController,
                                   dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAnalyticsConsentNavigationController = navigationController
        _receivedAnalyticsConsentDismissAction = dismissAction
        return _stubbedAnalyticsConsentCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedOnboardingCoordinator: BaseCoordinator?
    var _receivedOnboardingNavigationController: UINavigationController?
    var _receivedOnboardingDismissAction: (() -> Void)?
    override func onboarding(navigationController: UINavigationController,
                             dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedOnboardingNavigationController = navigationController
        _receivedOnboardingDismissAction = dismissAction
        return _stubbedOnboardingCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedTopicCoordinator: MockBaseCoordinator?
    override func topicDetail(_ topic: Topic,
                              navigationController: UINavigationController) -> BaseCoordinator {
        return _stubbedTopicCoordinator ?? MockBaseCoordinator()
    }

    var _receivedTopicOnboardingDidDismissAction: (() -> Void)?
    var _stubbedTopicOnboardingCoordinator: MockBaseCoordinator?
    override func topicOnboarding(navigationController: UINavigationController,
                                  didDismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedTopicOnboardingDidDismissAction = didDismissAction
        return _stubbedTopicOnboardingCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAppUnavailableDismissAction: (() -> Void)?
    var _stubbedAppUnavailableCoordinator: MockBaseCoordinator?
    override func appUnavailable(navigationController: UINavigationController,
                                 launchResponse: AppLaunchResponse,
                                 dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAppUnavailableDismissAction = dismissAction
        return _stubbedAppUnavailableCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAppForcedUpdateDismissAction: (() -> Void)?
    var _stubbedAppForcedUpdateCoordinator: MockBaseCoordinator?
    override func appForcedUpdate(navigationController: UINavigationController,
                                  launchResponse: AppLaunchResponse,
                                  dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAppForcedUpdateDismissAction = dismissAction
        return _stubbedAppForcedUpdateCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAppRecommendUpdateDismissAction: (() -> Void)?
    var _stubbedAppRecommendUpdateCoordinator: MockBaseCoordinator?
    override func appRecommendUpdate(navigationController: UINavigationController,
                                     launchResponse: AppLaunchResponse,
                                     dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAppRecommendUpdateDismissAction = dismissAction
        return _stubbedAppRecommendUpdateCoordinator ?? MockBaseCoordinator()
    }

    var _receivedNotificationOnboardingCompletion: (() -> Void)?
    var _stubbedNotificaitonOnboardingCoordinator: MockBaseCoordinator?
    override func notificationOnboarding(navigationController: UINavigationController,
                                         completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedNotificationOnboardingCompletion = completion
        return _stubbedNotificaitonOnboardingCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedNotificationSettingsCoordinator: MockBaseCoordinator?
    var _receivedNotificationSettingsCoordinatorCompletion: (() -> Void)?
    override func notificationSettings(navigationController: UINavigationController,
                                       completionAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedNotificationOnboardingCompletion = completionAction
        return _stubbedNotificationSettingsCoordinator ?? MockBaseCoordinator()
    }
}

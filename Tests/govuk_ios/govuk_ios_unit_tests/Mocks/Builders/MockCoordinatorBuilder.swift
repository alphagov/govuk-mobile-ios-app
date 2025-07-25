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

    var _stubbedPreAuthCoordinator: BaseCoordinator?
    var _receivedPreAuthNavigationController: UINavigationController?
    var _receivedPreAuthCompletion: (() -> Void)?
    override func preAuth(navigationController: UINavigationController,
                          completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedPreAuthNavigationController = navigationController
        _receivedPreAuthCompletion = completion
        return _stubbedPreAuthCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedPeriAuthCoordinator: BaseCoordinator?
    var _receivedPeriAuthCompletion: (() -> Void)?
    override func periAuth(navigationController: UINavigationController,
                           completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedPeriAuthCompletion = completion
        return _stubbedPeriAuthCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedPostAuthCoordinator: BaseCoordinator?
    var _receivedPostAuthCompletion: (() -> Void)?
    override func postAuth(navigationController: UINavigationController,
                           completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedPostAuthCompletion = completion
        return _stubbedPostAuthCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedTabCoordinator: BaseCoordinator?
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

    var _stubbedChatCoordinator: TabItemCoordinator?
    override var chat: any TabItemCoordinator {
        return _stubbedChatCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedJailbreakCoordinator: BaseCoordinator?
    var _receivedJailbreakDismissAction: (() -> Void)?
    override func jailbreakDetector(navigationController: UINavigationController,
                                    dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedJailbreakDismissAction = dismissAction
        return _stubbedJailbreakCoordinator ??
        MockBaseCoordinator(
            navigationController: .init()
        )
    }

    var _stubbedAnalyticsConsentCoordinator: BaseCoordinator?
    var _receivedAnalyticsConsentNavigationController: UINavigationController?
    var _receivedAnalyticsConsentCompletion: (() -> Void)?
    override func analyticsConsent(navigationController: UINavigationController,
                                   completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedAnalyticsConsentNavigationController = navigationController
        _receivedAnalyticsConsentCompletion = completion
        return _stubbedAnalyticsConsentCoordinator ??
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

    var _receivedAppUnavailableLaunchResponse: AppLaunchResponse?
    var _receivedAppUnavailableDismissAction: (() -> Void)?
    var _stubbedAppUnavailableCoordinator: MockBaseCoordinator?
    override func appUnavailable(navigationController: UINavigationController,
                                 launchResponse: AppLaunchResponse,
                                 dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAppUnavailableLaunchResponse = launchResponse
        _receivedAppUnavailableDismissAction = dismissAction
        return _stubbedAppUnavailableCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAppForcedUpdateDismissAction: (() -> Void)?
    var _receivedAppForcedUpdateLaunchResponse: AppLaunchResponse?
    var _stubbedAppForcedUpdateCoordinator: MockBaseCoordinator?
    override func appForcedUpdate(navigationController: UINavigationController,
                                  launchResponse: AppLaunchResponse,
                                  dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAppForcedUpdateLaunchResponse = launchResponse
        _receivedAppForcedUpdateDismissAction = dismissAction
        return _stubbedAppForcedUpdateCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAppRecommendUpdateLaunchResponse: AppLaunchResponse?
    var _receivedAppRecommendUpdateDismissAction: (() -> Void)?
    var _stubbedAppRecommendUpdateCoordinator: MockBaseCoordinator?
    override func appRecommendUpdate(navigationController: UINavigationController,
                                     launchResponse: AppLaunchResponse,
                                     dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedAppRecommendUpdateLaunchResponse = launchResponse
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
                                       completionAction: @escaping () -> Void,
                                       dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedNotificationOnboardingCompletion = completionAction
        return _stubbedNotificationSettingsCoordinator ?? MockBaseCoordinator()
    }

    var _receivedWelcomeOnboardingCompletion: (() -> Void)?
    var _stubbedWelcomeOnboardingCoordinator: MockBaseCoordinator?
    override func welcomeOnboarding(navigationController: UINavigationController,
                                    completionAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedWelcomeOnboardingCompletion = completionAction
        return _stubbedWelcomeOnboardingCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAuthenticationCompletion: (() -> Void)?
    var _receivedAuthenticationHandleError: ((AuthenticationError) -> Void)?
    var _stubbedAuthenticationCoordinator: MockBaseCoordinator?
    override func authentication(navigationController: UINavigationController,
                                 completionAction: @escaping () -> Void,
                                 handleError: @escaping (AuthenticationError) -> Void) -> BaseCoordinator {
        _receivedAuthenticationCompletion = completionAction
        _receivedAuthenticationHandleError = handleError
        return _stubbedAuthenticationCoordinator ?? MockBaseCoordinator()
    }

    var _receivedLocalAuthenticationOnboardingCompletion: (() -> Void)?
    var _stubbedLocalAuthenticationOnboardingCoordinator: MockBaseCoordinator?
    override func localAuthenticationOnboarding(navigationController: UINavigationController,
                                                completionAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedLocalAuthenticationOnboardingCompletion = completionAction
        return _stubbedLocalAuthenticationOnboardingCoordinator ?? MockBaseCoordinator()
    }

    var _receivedNotificationConsentCompletion: (() -> Void)?
    var _receivedNotificationConsentResult: NotificationConsentResult?
    var _stubbedNotificationConsentCoordinator: MockBaseCoordinator?
    override func notificationConsent(navigationController: UINavigationController,
                                      consentResult: NotificationConsentResult,
                                      completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedNotificationConsentCompletion = completion
        _receivedNotificationConsentResult = consentResult
        return _stubbedNotificationConsentCoordinator ?? MockBaseCoordinator()
    }

    var _receivedRelaunchCompletion: (() -> Void)?
    var _stubbedRelaunchCoordinator: MockBaseCoordinator?
    override func relaunch(navigationController: UINavigationController,
                           completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedRelaunchCompletion = completion
        return _stubbedRelaunchCoordinator ?? MockBaseCoordinator()
    }

    var _receivedReauthenticationCompletion: (() -> Void)?
    var _stubbedReauthenticationCoordinator: MockBaseCoordinator?
    override func reauthentication(navigationController: UINavigationController,
                                   completionAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedReauthenticationCompletion = completionAction
        return _stubbedReauthenticationCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedSignOutConfirmationCoordinator: MockBaseCoordinator?
    override func signOutConfirmation() -> BaseCoordinator {
        _stubbedSignOutConfirmationCoordinator ?? MockBaseCoordinator()
    }

    var _receivedSignInSuccessCompletion: (() -> Void)?
    var _signInSuccessCallAction: (() -> Void)?
    var _stubbedSignInSuccessCoordinator: MockBaseCoordinator?
    override func signInSuccess(navigationController: UINavigationController,
                                completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedSignInSuccessCompletion = completion
        _signInSuccessCallAction?()
        return _stubbedSignInSuccessCoordinator ?? MockBaseCoordinator()
    }

    var _receivedSafariCoordinatorURL: URL?
    var _receivedSafariCoordinatorFullScreen: Bool?
    var _stubbedSafariCoordinator: MockBaseCoordinator?
    override func safari(navigationController: UINavigationController,
                         url: URL,
                         fullScreen: Bool) -> BaseCoordinator {
        _receivedSafariCoordinatorURL = url
        _receivedSafariCoordinatorFullScreen = fullScreen
        return _stubbedSafariCoordinator ?? MockBaseCoordinator()
    }
}

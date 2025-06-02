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
                                       completionAction: @escaping () -> Void,
                                       dismissAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedNotificationOnboardingCompletion = completionAction
        return _stubbedNotificationSettingsCoordinator ?? MockBaseCoordinator()
    }

    var _receivedWelcomeOnboardingCompletion: (() -> Void)?
    var _stubbedWelcomeOnboardingCoordinator: MockBaseCoordinator?
    override func welcomeOnboarding(navigationController: UINavigationController,
                                    newUserAction: (() -> Void)?,
                                    completionAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedWelcomeOnboardingCompletion = completionAction
        return _stubbedWelcomeOnboardingCoordinator ?? MockBaseCoordinator()
    }

    var _receivedAuthenticationCompletion: (() -> Void)?
    var _receivedAuthenticationHandleError: ((AuthenticationError) -> Void)?
    var _stubbedAuthenticationCoordinator: MockBaseCoordinator?
    override func authentication(navigationController: UINavigationController,
                                 completionAction: @escaping () -> Void,
                                 newUserAction: (() -> Void)?,
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
    var _stubbedNotificationConsentCoordinator: MockBaseCoordinator?
    override func notificationConsent(navigationController: UINavigationController,
                                      consentResult: NotificationConsentResult,
                                      completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedNotificationConsentCompletion = completion
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
                                   completionAction: @escaping () -> Void,
                                   newUserAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedReauthenticationCompletion = completionAction
        return _stubbedReauthenticationCoordinator ?? MockBaseCoordinator()
    }

    var _stubbedSignOutConfirmationCoordinator: MockBaseCoordinator?
    override func signOutConfirmation() -> BaseCoordinator {
        _stubbedSignOutConfirmationCoordinator ?? MockBaseCoordinator()
    }

    var _receivedSignedOutCompletion: ((Bool) -> Void)?
    var _stubbedSignedOutCoordinator: MockBaseCoordinator?
    override func signedOut(navigationController: UINavigationController,
                            completion: @escaping (Bool) -> Void) -> BaseCoordinator {
        _receivedSignedOutCompletion = completion
        return _stubbedSignedOutCoordinator ?? MockBaseCoordinator()
    }

    var _receivedSignInErrorCompletion: (() -> Void)?
    var _stubbedSignInErrorCoordinator: MockBaseCoordinator?
    override func signInError(navigationController: UINavigationController,
                              completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedSignInErrorCompletion = completion
        return _stubbedSignInErrorCoordinator ?? MockBaseCoordinator()
    }

    var _receivedSignInSuccessCompletion: (() -> Void)?
    var _stubbedSignInSuccessCoordinator: MockBaseCoordinator?
    override func signInSuccess(navigationController: UINavigationController,
                                completion: @escaping () -> Void) -> BaseCoordinator {
        _receivedSignInSuccessCompletion = completion
        return _stubbedSignInSuccessCoordinator ?? MockBaseCoordinator()
    }

    var _receivedInactiveAction: (() -> Void)?
    var _stubbedInactivityCoordinator: MockBaseCoordinator?
    override func inactivityCoordinator(navigationController: UINavigationController,
                                        inactivityService: InactivityServiceInterface,
                                        inactiveAction: @escaping () -> Void) -> BaseCoordinator {
        _receivedInactiveAction = inactiveAction
        return _stubbedInactivityCoordinator ?? MockBaseCoordinator()
    }

    var _receivedSafariCoordinatorURL: URL?
    var _stubbedSafariCoordinator: MockBaseCoordinator?
    override func safari(navigationController: UINavigationController,
                         url: URL) -> BaseCoordinator {
        _receivedSafariCoordinatorURL = url
        return _stubbedSafariCoordinator ?? MockBaseCoordinator()
    }
}

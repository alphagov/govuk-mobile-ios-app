// swiftlint:disable file_length
import UIKit
import Foundation
import FactoryKit

@MainActor
// swiftlint:disable:next type_body_length
class CoordinatorBuilder {
    private let container: Container

    init(container: Container) {
        self.container = container
    }

    func app(
        navigationController: UINavigationController,
        inactivityService: InactivityServiceInterface
    ) -> BaseCoordinator {
        AppCoordinator(
            coordinatorBuilder: self,
            inactivityService: inactivityService,
            authenticationService: container.authenticationService.resolve(),
            localAuthenticationService: container.localAuthenticationService.resolve(),
            privacyPresenter: container.privacyService.resolve(),
            navigationController: navigationController
        )
    }

    func preAuth(navigationController: UINavigationController,
                 completion: @escaping () -> Void) -> BaseCoordinator {
        PreAuthCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController,
            completion: completion
        )
    }

    func periAuth(navigationController: UINavigationController,
                  completion: @escaping () -> Void) -> BaseCoordinator {
        PeriAuthCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController,
            completion: completion
        )
    }

    func postAuth(navigationController: UINavigationController,
                  completion: @escaping () -> Void) -> BaseCoordinator {
        PostAuthCoordinator(
            coordinatorBuilder: self,
            remoteConfigService: container.remoteConfigService.resolve(),
            navigationController: navigationController,
            completion: completion
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
            localAuthorityService: container.localAuthorityService.resolve(),
            userDefaultsService: container.userDefaultsService.resolve(),
            chatService: container.chatService.resolve()
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
            notificationService: container.notificationService.resolve(),
            localAuthenticationService: container.localAuthenticationService.resolve()
        )
    }

    func chat(cancelOnboardingAction: @escaping () -> Void) -> TabItemCoordinator {
        let navigationController = UINavigationController.chat

        return ChatCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            deepLinkStore: DeeplinkDataStore.chat(
                coordinatorBuilder: self,
                root: navigationController
            ),
            analyticsService: container.analyticsService.resolve(),
            chatService: container.chatService.resolve(),
            authenticationService: container.authenticationService(),
            cancelOnboardingAction: cancelOnboardingAction,
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

    func relaunch(navigationController: UINavigationController,
                  completion: @escaping () -> Void) -> BaseCoordinator {
        ReLaunchCoordinator(
            coordinatorBuilder: self,
            notificationService: container.notificationService.resolve(),
            navigationController: navigationController,
            completion: completion
        )
    }

    func jailbreakDetector(navigationController: UINavigationController,
                           dismissAction: @escaping () -> Void) -> BaseCoordinator {
        JailbreakCoordinator(
            navigationController: navigationController,
            jailbreakDetectionService: container.jailbreakDetectionService.resolve(),
            dismissAction: dismissAction
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
                          completion: @escaping () -> Void) -> BaseCoordinator {
        AnalyticsConsentCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            completion: completion
        )
    }

    func tab(navigationController: UINavigationController) -> BaseCoordinator {
        TabCoordinator(
            coordinatorBuilder: self,
            navigationController: navigationController,
            analyticsService: container.analyticsService()
        )
    }

    func recentActivity(navigationController: UINavigationController) -> BaseCoordinator {
        RecentActivityCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            activityService: container.activityService.resolve(),
            coordinatorBuilder: self
        )
    }

    func topicDetail(_ topic: Topic,
                     navigationController: UINavigationController) -> BaseCoordinator {
        TopicDetailsCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            topicsService: container.topicsService.resolve(),
            activityService: container.activityService.resolve(),
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            topic: topic
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

    func editLocalAuthority(navigationController: UINavigationController,
                            dismissAction: @escaping () -> Void) -> BaseCoordinator {
        EditLocalAuthorityCoordinator(
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
            notificationOnboardingService: container.notificationsOnboardingService.resolve(),
            analyticsService: container.analyticsService.resolve(),
            viewControllerBuilder: ViewControllerBuilder(),
            coordinatorBuilder: self,
            completion: completion
        )
    }

    func notificationConsent(navigationController: UINavigationController,
                             consentResult: NotificationConsentResult,
                             completion: @escaping () -> Void) -> BaseCoordinator {
        NotificationConsentCoordinator(
            navigationController: navigationController,
            notificationService: container.notificationService.resolve(),
            analyticsService: container.analyticsService.resolve(),
            consentResult: consentResult,
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            urlOpener: UIApplication.shared,
            completion: completion
        )
    }

    func notificationSettings(navigationController: UINavigationController,
                              completionAction: @escaping () -> Void,
                              dismissAction: @escaping () -> Void) -> BaseCoordinator {
        NotificationSettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            notificationService: container.notificationService.resolve(),
            coordinatorBuilder: self,
            completeAction: completionAction,
            dismissAction: dismissAction
        )
    }

    func welcomeOnboarding(navigationController: UINavigationController,
                           completionAction: @escaping () -> Void) -> BaseCoordinator {
        WelcomeOnboardingCoordinator(
            navigationController: navigationController,
            authenticationService: container.authenticationService.resolve(),
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            deviceInformationProvider: DeviceInformationProvider(),
            versionProvider: Bundle.main,
            completionAction: completionAction
        )
    }

    func authentication(navigationController: UINavigationController,
                        completionAction: @escaping () -> Void,
                        errorAction: @escaping (AuthenticationError) -> Void) -> BaseCoordinator {
        AuthenticationCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: self,
            authenticationService: container.authenticationService.resolve(),
            localAuthenticationService: container.localAuthenticationService.resolve(),
            analyticsService: container.analyticsService.resolve(),
            topicsService: container.topicsService.resolve(),
            chatService: container.chatService.resolve(),
            completionAction: completionAction,
            errorAction: errorAction
        )
    }

    func reauthentication(navigationController: UINavigationController,
                          completionAction: @escaping () -> Void) -> BaseCoordinator {
        ReAuthenticationCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: self,
            authenticationService: container.authenticationService.resolve(),
            localAuthenticationService: container.localAuthenticationService.resolve(),
            analyticsService: container.analyticsService.resolve(),
            completionAction: completionAction
        )
    }

    func localAuthenticationOnboarding(navigationController: UINavigationController,
                                       completionAction: @escaping () -> Void) -> BaseCoordinator {
        LocalAuthenticationOnboardingCoordinator(
            navigationController: navigationController,
            userDefaultsService: container.userDefaultsService.resolve(),
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

    func signInSuccess(navigationController: UINavigationController,
                       completion: @escaping () -> Void) -> BaseCoordinator {
        SignInSuccessCoordinator(
            navigationController: navigationController,
            analyticsService: container.analyticsService.resolve(),
            authenticationService: container.authenticationService.resolve(),
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

    func safari(navigationController: UINavigationController,
                url: URL,
                fullScreen: Bool) -> BaseCoordinator {
        SafariCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            configService: container.appConfigService.resolve(),
            urlOpener: UIApplication.shared,
            url: url,
            fullScreen: fullScreen
        )
    }

    func localAuthenticationSettings(
        navigationController: UINavigationController
    ) -> BaseCoordinator {
        LocalAuthenticationSettingsCoordinator(
            navigationController: navigationController,
            authenticationService: container.authenticationService.resolve(),
            localAuthenticationService: container.localAuthenticationService.resolve(),
            analyticsService: container.analyticsService.resolve(),
            viewControllerBuilder: ViewControllerBuilder(),
            urlOpener: UIApplication.shared
        )
    }

    func chatInfoOnboarding(
        cancelOnboardingAction: @escaping () -> Void,
        setChatViewControllerAction: @escaping (Bool) -> Void
    ) -> BaseCoordinator {
        ChatInfoOnboardingCoordinator(
            navigationController: UINavigationController(),
            coordinatorBuilder: self,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            cancelOnboardingAction: cancelOnboardingAction,
            setChatViewControllerAction: setChatViewControllerAction
        )
    }

    func chatConsentOnboarding(
        navigationController: UINavigationController,
        cancelOnboardingAction: @escaping () -> Void,
        completionAction: @escaping () -> Void
    ) -> BaseCoordinator {
        ChatConsentOnboardingCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: ViewControllerBuilder(),
            analyticsService: container.analyticsService.resolve(),
            chatService: container.chatService.resolve(),
            cancelOnboardingAction: cancelOnboardingAction,
            completionAction: completionAction
        )
    }

    func privacy(
        navigationController: UINavigationController
    ) -> BaseCoordinator & PrivacyProviding {
        PrivacyCoordinator(
            navigationController: navigationController
        )
    }
}

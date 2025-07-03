import UIKit
import Foundation
import GOVKit

class SettingsCoordinator: TabItemCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private var settingsViewModel: any SettingsViewModelInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface
    let authenticationService: AuthenticationServiceInterface
    private let notificationService: NotificationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         deviceInformationProvider: DeviceInformationProviderInterface,
         authenticationService: AuthenticationServiceInterface,
         notificationService: NotificationServiceInterface,
         localAuthenticationService: LocalAuthenticationServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.authenticationService = authenticationService
        self.notificationService = notificationService
        self.localAuthenticationService = localAuthenticationService
        self.settingsViewModel = SettingsViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            versionProvider: Bundle.main,
            deviceInformationProvider: deviceInformationProvider,
            authenticationService: authenticationService,
            notificationService: notificationService,
            notificationCenter: .default,
            localAuthenticationService: localAuthenticationService
        )
        super.init(navigationController: navigationController)
        setViewModelActions()
    }

    override func start(url: URL?) {
        let viewController = viewControllerBuilder.settings(
            viewModel: settingsViewModel
        )
        set([viewController], animated: false)
    }

    func route(for url: URL) -> ResolvedDeeplinkRoute? {
        deeplinkStore.route(
            for: url,
            parent: self
        )
    }

    func didReselectTab() {
        settingsViewModel.scrollToTop = true
    }

    private func setViewModelActions() {
        settingsViewModel.notificationsAction = { [weak self] in
            self?.startNotificationsSettings()
        }
        settingsViewModel.localAuthenticationAction = { [weak self] in
            self?.startLocalAuthenticationSettings()
        }
        settingsViewModel.signoutAction = { [weak self] in
            self?.startSignOut()
        }
        settingsViewModel.openAction = { [weak self] params in
            self?.presentWebView(
                url: params.url,
                fullScreen: params.fullScreen
            )
        }
    }

    private func startNotificationsSettings() {
        let coordinator = coordinatorBuilder.notificationSettings(
            navigationController: root,
            completionAction: { [weak self] in
                self?.root.popToRootViewController(animated: true)
            },
            dismissAction: { [weak self] in
                self?.root.popToRootViewController(animated: true)
            }
        )
        start(coordinator)
    }

    private func startLocalAuthenticationSettings() {
        let coordinator = coordinatorBuilder.localAuthenticationSettings(
            navigationController: root
        )
        start(coordinator)
    }

    private func presentWebView(url: URL, fullScreen: Bool) {
        let coordinator = coordinatorBuilder.safari(
            navigationController: root,
            url: url,
            fullScreen: fullScreen
        )
        start(coordinator)
    }

    private func startSignOut() {
        let coordinator = coordinatorBuilder.signOutConfirmation()
        present(coordinator)
    }
}

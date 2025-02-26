import UIKit
import Foundation
import GOVKit

class SettingsCoordinator: TabItemCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let settingsViewModel: any SettingsViewModelInterface
    private let configService: AppConfigServiceInterface
    private let dismissAction: () -> Void

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         deviceInformationProvider: DeviceInformationProviderInterface,
         configService: AppConfigServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.configService = configService
        self.dismissAction = dismissAction
        self.settingsViewModel = SettingsViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            versionProvider: Bundle.main,
            deviceInformationProvider: deviceInformationProvider,
            configService: configService,
            notificationsAuthStatus: NotificationsAuthStatus(),
            dismissAction: dismissAction
        )

        super.init(navigationController: navigationController)
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
}

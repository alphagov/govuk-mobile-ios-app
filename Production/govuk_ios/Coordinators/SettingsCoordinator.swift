import UIKit
import Foundation

class SettingsCoordinator: TabItemCoordinator {
    private let coordinatorBuilder: CoordinatorBuilder
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private let analyticsService: AnalyticsServiceInterface
    private let deviceInformation: DeviceInformationInterface
    private let settingsViewModel: any SettingsViewModelInterface

    init(navigationController: UINavigationController,
         coordinatorBuilder: CoordinatorBuilder,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         deviceInformation: DeviceInformationInterface) {
        self.coordinatorBuilder = coordinatorBuilder
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        self.deviceInformation = deviceInformation
        self.settingsViewModel = SettingsViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            versionProvider: Bundle.main,
            deviceInformation: deviceInformation
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

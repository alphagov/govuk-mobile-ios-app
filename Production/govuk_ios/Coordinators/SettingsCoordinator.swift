import UIKit
import Foundation
import GOVKit

class SettingsCoordinator: TabItemCoordinator {
    private let viewControllerBuilder: ViewControllerBuilder
    private let deeplinkStore: DeeplinkDataStore
    private var settingsViewModel: any SettingsViewModelInterface
    private let coordinatorBuilder: CoordinatorBuilder
    private let analyticsService: AnalyticsServiceInterface

    init(navigationController: UINavigationController,
         viewControllerBuilder: ViewControllerBuilder,
         deeplinkStore: DeeplinkDataStore,
         analyticsService: AnalyticsServiceInterface,
         coordinatorBuilder: CoordinatorBuilder,
         deviceInformationProvider: DeviceInformationProviderInterface,
         notificationService: NotificationServiceInterface) {
        self.viewControllerBuilder = viewControllerBuilder
        self.deeplinkStore = deeplinkStore
        self.analyticsService = analyticsService
        self.coordinatorBuilder = coordinatorBuilder
        self.settingsViewModel = SettingsViewModel(
            analyticsService: analyticsService,
            urlOpener: UIApplication.shared,
            versionProvider: Bundle.main,
            deviceInformationProvider: deviceInformationProvider,
            notificationService: notificationService
        )
        super.init(navigationController: navigationController)
        self.settingsViewModel.dismissAction = { [weak self] in
            self?.presentNotificationsOnboardingCoordinator()
        }
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

    private func presentNotificationsOnboardingCoordinator() {
        let coordinator = coordinatorBuilder.notificationOnboarding(
            navigationController: root,
            completion: { [weak self] in
                self?.start(url: nil)
            }
        )
        start(coordinator)
    }
}

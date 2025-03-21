import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
struct SettingsCoordinatorTests {

    init() {
        UIView.setAnimationsEnabled(false)
    }

    @Test
    func start_setsSettingsViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: CoordinatorBuilder.mock,
            deviceInformationProvider: MockDeviceInformationProvider(),
            notificationService: MockNotificationService()
        )
        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }
    
    @Test
    func didReselectTab_updatesViewModel() throws {
        let viewControllerBuilder = ViewControllerBuilder()
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: viewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: []),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: CoordinatorBuilder.mock,
            deviceInformationProvider: MockDeviceInformationProvider(),
            notificationService: MockNotificationService()
        )
        subject.start()

        let settingsViewController = try #require(subject.root.viewControllers.first as?
        HostingViewController<SettingsView<SettingsViewModel>>)
        #expect(settingsViewController.rootView.viewModel.scrollToTop == false)
        subject.didReselectTab()
        #expect(settingsViewController.rootView.viewModel.scrollToTop == true)
    }
}

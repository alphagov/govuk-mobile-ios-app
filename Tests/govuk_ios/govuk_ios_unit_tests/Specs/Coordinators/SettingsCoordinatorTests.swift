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
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: CoordinatorBuilder.mock,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    func start_passesHydratedViewModel() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: CoordinatorBuilder.mock,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start(url: nil)

        #expect(mockViewControllerBuilder._receivedSettingsViewModel?.notificationsAction != nil)
    }

    @Test
    func selectingNotifications_startsNotificationOnboarding() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNotificationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationSettingsCoordinator = mockNotificationCoordinator
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start(url: nil)
        mockViewControllerBuilder._receivedSettingsViewModel?.notificationsAction?()
        #expect(mockNotificationCoordinator._startCalled)
    }

    @Test
    func completingNotifications_popsViewController() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockNotificationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedNotificationSettingsCoordinator = mockNotificationCoordinator
        let mockNavigationController = MockNavigationController()
        let subject = SettingsCoordinator(
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start(url: nil)
        mockViewControllerBuilder._receivedSettingsViewModel?.notificationsAction?()
        mockCoordinatorBuilder._receivedNotificationOnboardingCompletion?()
        #expect(mockNavigationController._popToRootCalled)
    }

    @Test
    func selectingOpenAction_presentsSafariViewController() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController

        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start()
        let settingsViewModel = mockViewControllerBuilder._receivedSettingsViewModel!
        let params = SettingsViewModelURLParameters(
            url: Constants.API.privacyPolicyUrl,
            trackingTitle: "Privacy Policy",
            fullScreen: false
        )
        settingsViewModel.openAction?(params)
        #expect(mockSafariCoordinator._startCalled)
        #expect(mockCoordinatorBuilder._receivedSafariCoordinatorURL == Constants.API.privacyPolicyUrl)
        #expect(mockCoordinatorBuilder._receivedSafariCoordinatorFullScreen == .some(false))
    }

    @Test
    func didReselectTab_updatesViewModel() throws {
        let viewControllerBuilder = ViewControllerBuilder()
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: viewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: CoordinatorBuilder.mock,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start()

        let settingsViewController = try #require(subject.root.viewControllers.first as?
                                                  HostingViewController<SettingsView<SettingsViewModel>>)
        #expect(settingsViewController.rootView.viewModel.scrollToTop == false)
        subject.didReselectTab()
        #expect(settingsViewController.rootView.viewModel.scrollToTop == true)
    }

    @Test
    func selecting_signOut_starts_signOutConfirmation() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSettingsViewController = expectedViewController
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let mockSignOutConfirmationCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSignOutConfirmationCoordinator = mockSignOutConfirmationCoordinator
        let navigationController = UINavigationController()
        let subject = SettingsCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: DeeplinkDataStore(routes: [], root: UIViewController()),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService()
        )
        subject.start(url: nil)
        mockViewControllerBuilder._receivedSettingsViewModel?.signoutAction?()
        #expect(mockSignOutConfirmationCoordinator._startCalled)
    }
}

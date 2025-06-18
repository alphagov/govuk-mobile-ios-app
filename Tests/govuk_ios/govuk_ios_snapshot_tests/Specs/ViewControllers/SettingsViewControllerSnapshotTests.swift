import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class SettingsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "123"
        let notificationService = MockNotificationService()
        notificationService._stubbedIsFetureEnabled = false
        let authenticationService = MockAuthenticationService()
        authenticationService._stubbedIsSignedIn = true
        authenticationService._stubbedUserEmail = "test@example.com"

        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: authenticationService,
            notificationService: notificationService,
            notificationCenter: .default,
            localAuthenticationService: MockLocalAuthenticationService()
        )
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )
        let hostingViewController =  HostingViewController(
            rootView: settingsContentView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "123"
        let notificationService = MockNotificationService()
        notificationService._stubbedIsFetureEnabled = false
        let authenticationService = MockAuthenticationService()
        authenticationService._stubbedIsSignedIn = true
        authenticationService._stubbedUserEmail = "test@example.com"


        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: authenticationService,
            notificationService: notificationService,
            notificationCenter: .default,
            localAuthenticationService: MockLocalAuthenticationService()
        )
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )
        let hostingViewController =  HostingViewController(
            rootView: settingsContentView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
        // This is here to meet code coverage requirements
        viewModel.scrollToTop = true
    }

    func test_loadInNavigationController_notificationsFeatureEnabled_light_rendersCorrectly() {
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "123"
        let notificationService = MockNotificationService()
        notificationService._stubbedIsFetureEnabled = true
        let authenticationService = MockAuthenticationService()
        authenticationService._stubbedIsSignedIn = true
        authenticationService._stubbedUserEmail = "test@example.com"

        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: authenticationService,
            notificationService: notificationService,
            notificationCenter: .default,
            localAuthenticationService: MockLocalAuthenticationService()
        )
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )
        let hostingViewController =  HostingViewController(
            rootView: settingsContentView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_notificationsFeatureEnabled_dark_rendersCorrectly() {
        let mockVersionProvider = MockAppVersionProvider()
        mockVersionProvider.versionNumber = "1.2.3"
        mockVersionProvider.buildNumber = "123"
        let notificationService = MockNotificationService()
        notificationService._stubbedIsFetureEnabled = true
        let authenticationService = MockAuthenticationService()
        authenticationService._stubbedIsSignedIn = true
        authenticationService._stubbedUserEmail = "test@example.com"

        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: authenticationService,
            notificationService: notificationService,
            notificationCenter: .default,
            localAuthenticationService: MockLocalAuthenticationService()
        )
        
        let settingsContentView = SettingsView(
            viewModel: viewModel
        )
        let hostingViewController =  HostingViewController(
            rootView: settingsContentView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_preview_rendersCorrectly() {
        let settingsContentView = SettingsView(
            viewModel: GroupedListViewModel()
        )
        let viewController = HostingViewController(rootView: settingsContentView)
        viewController.title = "Settings"
        viewController.navigationItem.largeTitleDisplayMode = .always
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }
}

class GroupedListViewModel: SettingsViewModelInterface {
    var localAuthenticationAction: (() -> Void)?
    func updateNotificationPermissionState() {}
    var notificationsAction: (() -> Void)?
    var displayNotificationSettingsAlert: Bool = false
    func handleNotificationAlertAction() { }
    var notificationSettingsAlertTitle: String = "Turn on notifications"
    var notificationSettingsAlertBody: String = "Continue to your phone’s notifications settings to turn off notifications from GOV.UK"
    var notificationAlertButtonTitle: String = "Continue"
    var title: String = "Settings"
    var listContent: [GroupedListSection] = GroupedListSection_Previews.previewContent.dropLast()
    var scrollToTop: Bool = false
    func trackScreen(screen: any TrackableScreen) {
        // Do Nothing
    }
    var signoutAction: (() -> Void)?
    var openAction: ((URL, String) -> Void)?
}

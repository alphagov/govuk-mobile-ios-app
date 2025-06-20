import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

class TouchIdSettingsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedDeviceCapableAuthType = .touchID
        let viewModel = LocalAuthenticationSettingsViewModel(
            authenticationService: MockAuthenticationService(),
            localAuthenticationService: mockLocalAuthenticationService,
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )
        let touchIdSettingsView = TouchIdSettingsView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: touchIdSettingsView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedDeviceCapableAuthType = .touchID
        let viewModel = LocalAuthenticationSettingsViewModel(
            authenticationService: MockAuthenticationService(),
            localAuthenticationService: mockLocalAuthenticationService,
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )
        let touchIdSettingsView = TouchIdSettingsView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: touchIdSettingsView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}


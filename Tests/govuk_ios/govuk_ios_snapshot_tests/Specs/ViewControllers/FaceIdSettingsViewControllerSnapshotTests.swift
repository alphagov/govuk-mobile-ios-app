import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios

class FaceIdSettingsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedDeviceCapableAuthType = .faceID
        let viewModel = LocalAuthenticationSettingsViewModel(
            authenticationService: MockAuthenticationService(),
            localAuthenticationService: mockLocalAuthenticationService,
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )
        let faceIdSettingsView = FaceIdSettingsView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: faceIdSettingsView,
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
        mockLocalAuthenticationService._stubbedDeviceCapableAuthType = .faceID
        let viewModel = LocalAuthenticationSettingsViewModel(
            authenticationService: MockAuthenticationService(),
            localAuthenticationService: mockLocalAuthenticationService,
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener()
        )
        let faceIdSettingsView = FaceIdSettingsView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: faceIdSettingsView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}

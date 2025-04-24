import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios

class LocalAuthenticationOnboardingViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        let viewModel = LocalAuthenticationOnboardingViewModel(
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: MockAuthenticationService(),
            analyticsService: MockAnalyticsService(),
            completionAction: {}
        )
        let settingsContentView = LocalAuthenticationOnboardingView(
            viewModel: viewModel
        )
        let hostingViewController =  HostingViewController(
            rootView: settingsContentView
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAuthType = .faceID
        let viewModel = LocalAuthenticationOnboardingViewModel(
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: MockAuthenticationService(),
            analyticsService: MockAnalyticsService(),
            completionAction: {}
        )
        let settingsContentView = LocalAuthenticationOnboardingView(
            viewModel: viewModel
        )
        let hostingViewController =  HostingViewController(
            rootView: settingsContentView
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}

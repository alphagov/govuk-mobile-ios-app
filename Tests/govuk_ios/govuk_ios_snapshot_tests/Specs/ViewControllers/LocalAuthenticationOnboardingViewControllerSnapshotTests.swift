import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios

class LocalAuthenticationOnboardingViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_faceID_light_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let viewModel = LocalAuthenticationOnboardingViewModel(
            userDefaults: MockUserDefaultsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: MockAuthenticationService(),
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

    func test_loadInNavigationController_faceID_dark_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .faceID
        let viewModel = LocalAuthenticationOnboardingViewModel(
            userDefaults: MockUserDefaultsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: MockAuthenticationService(),
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

    func test_loadInNavigationController_touchID_light_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let viewModel = LocalAuthenticationOnboardingViewModel(
            userDefaults: MockUserDefaultsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: MockAuthenticationService(),
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

    func test_loadInNavigationController_touchID_dark_rendersCorrectly() {
        let mockLocalAuthenticationService = MockLocalAuthenticationService()
        mockLocalAuthenticationService._stubbedAvailableAuthType = .touchID
        let viewModel = LocalAuthenticationOnboardingViewModel(
            userDefaults: MockUserDefaultsService(),
            localAuthenticationService: mockLocalAuthenticationService,
            authenticationService: MockAuthenticationService(),
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

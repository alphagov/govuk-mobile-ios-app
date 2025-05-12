import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class SignedOutViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = SignedOutViewModel(authenticationService: MockAuthenticationService(),
                                           analyticsService: MockAnalyticsService(),
                                           completion: { })
        let signedOutView = AuthenticationInfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signedOutView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = SignedOutViewModel(authenticationService: MockAuthenticationService(),
                                           analyticsService: MockAnalyticsService(),
                                           completion: { })
        let signedOutView = AuthenticationInfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signedOutView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_with_error_light_rendersCorrectly() {
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let viewModel = SignedOutViewModel(authenticationService: mockAuthenticationService,
                                           analyticsService: MockAnalyticsService(),
                                           completion: { })
        let signedOutView = AuthenticationInfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signedOutView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_with_error_dark_rendersCorrectly() {
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let viewModel = SignedOutViewModel(authenticationService: mockAuthenticationService,
                                           analyticsService: MockAnalyticsService(),
                                           completion: { })
        let signedOutView = AuthenticationInfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signedOutView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}

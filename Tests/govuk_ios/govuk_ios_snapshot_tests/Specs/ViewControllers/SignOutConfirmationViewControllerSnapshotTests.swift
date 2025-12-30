import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios

@MainActor
class SignOutConfirmationViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = SignOutConfirmationViewModel(authenticationService: MockAuthenticationService(),
                                                     analyticsService: MockAnalyticsService(),
                                                     completion: { _ in })
        let signOutConfirmationView = SignOutConfirmationView(
            viewModel: viewModel
        )
        let hostingViewController = HostingViewController(
            rootView: signOutConfirmationView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = SignOutConfirmationViewModel(authenticationService: MockAuthenticationService(),
                                                     analyticsService: MockAnalyticsService(),
                                                     completion: { _ in })
        let signOutConfirmationView = SignOutConfirmationView(
            viewModel: viewModel
        )
        let hostingViewController = HostingViewController(
            rootView: signOutConfirmationView,
            statusBarStyle: .darkContent
        )
        hostingViewController.view.backgroundColor = .clear
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}


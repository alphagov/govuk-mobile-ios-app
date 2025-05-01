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
        let signedOutView = SignedOutView(viewModel: viewModel)
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
        let signedOutView = SignedOutView(viewModel: viewModel)
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

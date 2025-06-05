import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

class SignInSuccessViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = SignInSuccessViewModel(
            analyticsService: MockAnalyticsService(),
            completion: { }
        )
        let signInSuccessView = InfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signInSuccessView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = SignInSuccessViewModel(
            analyticsService: MockAnalyticsService(),
            completion: { }
        )
        let signInSuccessView = InfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signInSuccessView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }
}

import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class SignInErrorViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewModel = SignInErrorViewModel(
            error: .loginFlow(.init(reason: .authorizationAccessDenied)),
            completion: { }
        )
        let signInErrorView = InfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signInErrorView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewModel = SignInErrorViewModel(
            error: .loginFlow(.init(reason: .authorizationAccessDenied)),
            completion: { }
        )
        let signInErrorView = InfoView(viewModel: viewModel)
        let hostingViewController =  HostingViewController(
            rootView: signInErrorView,
            statusBarStyle: .darkContent
        )
        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }

}

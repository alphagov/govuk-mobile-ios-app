import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class LocalAuthorityExplainerViewSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController() -> UIViewController {
        let viewModel = LocalAuthorityExplainerViewModel(
            analyticsService: MockAnalyticsService(),
            navigateToPostcodeEntry: {},
            dismissAction: {}
        )
        let view = LocalAuthorityExplainerView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}


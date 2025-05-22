import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class AmbiguousAuthorityViewControllerSnapshotTests: SnapshotTestCase {
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
        let ambigiousAuthorities = AmbiguousAuthorities.arrange()

        let viewModel = AmbiguousAuthoritySelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: MockLocalAuthorityService(),
            ambiguousAuthorities: ambigiousAuthorities,
            postCode: "BH22 8UB",
            selectAddressAction: {},
            dismissAction: {})

        let view = AmbiguousAuthoritySelectionView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}

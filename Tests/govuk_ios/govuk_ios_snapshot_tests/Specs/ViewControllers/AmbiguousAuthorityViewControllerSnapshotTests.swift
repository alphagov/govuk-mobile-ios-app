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
        let authorityOne = Authority(
            name: "Bournemouth, Christchurch and Poole Council",
            homepageUrl: "homepageURL1",
            tier: "tier1",
            slug: "slug1"
        )
        let authorityTwo = Authority(
            name: "Dorset Council",
            homepageUrl: "homepageUR2",
            tier: "tier2",
            slug: "slug2"
        )
        let addressOne = LocalAuthorityAddress(
            address: "address1",
            slug: "slug1",
            name: "Bournemouth, Christchurch and Poole Council"
        )
        let addressTwo = LocalAuthorityAddress(
            address: "address2",
            slug: "slug2",
            name: "Dorset Council"
        )
        let ambigiousAuthorities = AmbiguousAuthorities(
            authorities: [authorityOne, authorityTwo],
            addresses: [addressOne, addressTwo]
        )

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

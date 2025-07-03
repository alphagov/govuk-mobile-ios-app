import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class AmbiguousAddressViewControllerSnapshotTests: SnapshotTestCase {
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
            address: "APPLETREE COTTAGE, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
            slug: "slug1",
            name: "Bournemouth, Christchurch and Poole Council"
        )
        let addressTwo = LocalAuthorityAddress(
            address: "ASHLEA, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
            slug: "slug2",
            name: "Dorset Council"
        )
        let addressThree = LocalAuthorityAddress(
            address: "UNIT 1, BARNES BUSINESS PARK, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
            slug: "slug1",
            name: "Bournemouth, Christchurch and Poole Council"
        )
        let addressFour = LocalAuthorityAddress(
            address: "UNIT 6, BARNES BUSINESS PARK, BARRACK ROAD, WEST PARLEY, FERNDOWN, BH22 8UB",
            slug: "slug2",
            name: "Dorset Council"
        )
        let ambigiousAuthorities = AmbiguousAuthorities(
            authorities: [authorityOne, authorityTwo],
            addresses: [addressOne, addressTwo, addressThree, addressFour]
        )

        let viewModel = AmbiguousAddressSelectionViewModel(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: MockLocalAuthorityService(),
            ambiguousAuthorities: ambigiousAuthorities,
            localAuthoritySelected: {_ in},
            dismissAction: { }
        )

        let view = AmbiguousAddressSelectionView(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}

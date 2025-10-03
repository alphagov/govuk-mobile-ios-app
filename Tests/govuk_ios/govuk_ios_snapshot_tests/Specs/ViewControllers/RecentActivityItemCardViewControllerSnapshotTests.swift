import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class RecentActivityItemCardViewControllerSnapshotTests: SnapshotTestCase {

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
        let model = RecentActivityHomepageCell(
            title: "Test",
            lastVisitedString: ""
        )
        let view = RecentActivityItemCard(
            model: model,
            isLastItemInList: false
        )
        return HostingViewController(rootView: view)
    }
}

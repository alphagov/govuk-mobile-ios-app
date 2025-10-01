import Foundation
import XCTest
import UIKit
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class PrivacyViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let privacyView = PrivacyView()
        let hostingViewController = HostingViewController(rootView: privacyView)

        VerifySnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }
}

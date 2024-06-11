import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class LaunchViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let subject = LaunchViewController()
        VerifySnapshotInWindow(subject)
    }
}

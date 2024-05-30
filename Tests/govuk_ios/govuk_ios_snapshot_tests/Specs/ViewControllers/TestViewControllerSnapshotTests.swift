import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class TestViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let subject = TestViewController(
            color: .green,
            tabTitle: "Orange",
            nextAction: {},
            modalAction: {}
        )
        VerifySnapshotInWindow(subject)
    }
}

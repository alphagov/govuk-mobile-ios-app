import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class TestViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let viewModel = TestViewModel(
            color: .green,
            tabTitle: "Orange",
            nextAction: {},
            modalAction: {}
        )
        let subject = TestViewController(
            viewModel: viewModel
        )
        VerifySnapshotInWindow(subject)
    }
}

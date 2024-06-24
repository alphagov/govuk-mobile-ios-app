import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class TestViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let viewModel = TestViewModel(
            color: .green,
            tabTitle: "Orange",
            primaryTitle: "Next",
            primaryAction: {},
            secondaryTitle: "Modal",
            secondaryAction: {}
        )
        let subject = TestViewController(
            viewModel: viewModel
        )
        VerifySnapshotInWindow(subject)
    }

    func test_loadInNavigationController_withModalAction_rendersCorrectly() {
        let viewModel = TestViewModel(
            color: .green,
            tabTitle: "Orange",
            primaryTitle: "Next",
            primaryAction: {},
            secondaryTitle: nil,
            secondaryAction: nil
        )
        let subject = TestViewController(
            viewModel: viewModel
        )
        VerifySnapshotInWindow(subject)
    }
}

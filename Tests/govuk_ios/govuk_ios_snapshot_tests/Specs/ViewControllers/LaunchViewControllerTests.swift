import Foundation
import XCTest
import UIKit

@testable import govuk_ios

class LaunchViewControllerTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let viewModel = LaunchViewModel(
            animationCompleted: {

            }
        )
        let subject = LaunchViewController(
            viewModel: viewModel
        )
        subject.overrideUserInterfaceStyle = .light

        VerifySnapshotInWindow(subject)
    }
}

import Foundation
import XCTest
import UIKit

import Factory

@testable import govuk_ios

class LaunchViewControllerSnapshotTests: SnapshotTestCase {
    private var mockAccessibilityManager: MockAccessibilityManager!

    override func setUp() {
        super.setUp()
        mockAccessibilityManager = MockAccessibilityManager()
        Container.shared.accessibilityManager.register(
            factory: {
                self.mockAccessibilityManager
            }
        )
    }

    func test_loadInNavigationController_rendersCorrectly() {
        mockAccessibilityManager.animationsEnabled = false

        let viewModel = LaunchViewModel(
            animationCompleted: { }
        )
        let subject = LaunchViewController(
            viewModel: viewModel
        )
        subject.overrideUserInterfaceStyle = .light

        VerifySnapshotInWindow(subject)
    }
}

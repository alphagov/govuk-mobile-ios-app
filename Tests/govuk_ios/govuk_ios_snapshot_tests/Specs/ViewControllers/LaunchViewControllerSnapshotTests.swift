import Foundation
import XCTest
import UIKit

import FactoryKit

@testable import govuk_ios

@MainActor
class LaunchViewControllerSnapshotTests: SnapshotTestCase {
    private var mockAccessibilityManager: MockAccessibilityManager!

    override func setUp() {
        super.setUp()
        let mockManager = MockAccessibilityManager()
        Container.shared.accessibilityManager.register { mockManager }
        self.mockAccessibilityManager = mockManager
    }

    func test_loadInNavigationController_rendersCorrectly() {
        mockAccessibilityManager.animationsEnabled = false

        let viewModel = LaunchViewModel(
            animationsCompletedAction: { }
        )
        let subject = LaunchViewController(
            viewModel: viewModel,
            analyticsService: MockAnalyticsService()
        )
        subject.overrideUserInterfaceStyle = .light

        VerifySnapshotInWindow(subject)
    }
}

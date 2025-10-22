import Foundation
import XCTest
import UIKit

import Factory

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class LaunchViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_rendersCorrectly() {
        let mockAccessibilityManager = MockAccessibilityManager()
        mockAccessibilityManager.animationsEnabled = false
        let container = Container.shared
        container.accessibilityManager.register { mockAccessibilityManager }

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

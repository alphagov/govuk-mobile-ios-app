import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class NotificationConsentAlertViewControllerSnapshotTests: SnapshotTestCase {
    func test_load_light_rendersCorrectly() {
        let viewController = NotificationConsentAlertViewController(
            analyticsService: MockAnalyticsService()
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_load_dark_rendersCorrectly() {
        let viewController = NotificationConsentAlertViewController(
            analyticsService: MockAnalyticsService()
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }
}


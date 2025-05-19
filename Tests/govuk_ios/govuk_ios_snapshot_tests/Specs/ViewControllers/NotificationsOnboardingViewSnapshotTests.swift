import Foundation
import XCTest
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class NotificationsOnboardingViewSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let viewController = ViewControllerBuilder().notificationOnboarding(
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let viewController = ViewControllerBuilder().notificationOnboarding(
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_notificationSettings_light_rendersCorrectly() {
        let viewController = ViewControllerBuilder().notificationSettings(
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_notificationSettings_dark_rendersCorrectly() {
        let viewController = ViewControllerBuilder().notificationSettings(
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { }
        )

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }
}

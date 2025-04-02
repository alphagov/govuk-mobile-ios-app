import Foundation
import XCTest
import UIKit
import GOVKit
import Combine
import Onboarding

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
class NotificationSettingsViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockNotificationService = MockNotificationService()

        let viewModel = NotificationSettingsViewModel(
            notificationService: mockNotificationService,
            analyticsService: MockAnalyticsService(),
            completeAction: {}
        )
        let subject = NotificationSettingsView(
            viewModel: viewModel,
            analyticsService: MockAnalyticsService()
        )
        let hostingViewController = HostingViewController(
            rootView: subject
        )
        RecordSnapshotInNavigationController(
            viewController: hostingViewController,
            mode: .light,
            prefersLargeTitles: false
        )
    }
}

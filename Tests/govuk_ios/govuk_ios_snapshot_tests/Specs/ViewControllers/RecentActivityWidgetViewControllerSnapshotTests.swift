import Foundation
import XCTest
import UIKit
import GOVKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

@MainActor
final class RecentActivityWidgetViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_emptyActivities_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light
        )
    }

    func test_loadInNavigationController_emptyActivities_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark
        )
    }


    private func viewController() -> UIViewController {
        let viewModel = RecentActivtyHomepageWidgetViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            seeAllAction: {}
        )
        let view = RecentActivityWidget(viewModel: viewModel)
        return HostingViewController(rootView: view)
    }
}


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
            viewController: viewController(populated: false),
            mode: .light
        )
    }

    func test_loadInNavigationController_emptyActivities_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(populated: false),
            mode: .dark
        )
    }

    func test_loadInNavigationController_populated_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(populated: true),
            mode: .light
        )
    }

    func test_loadInNavigationController_populated_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(populated: true),
            mode: .dark
        )
    }


    private func viewController(populated: Bool) -> UIViewController {
        let viewModel = RecentActivtyHomepageWidgetViewModel(
            urlOpener: MockURLOpener(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            seeAllAction: {}
        )
        if populated {
            let cell = RecentActivityHomepageCell(
                title: "title", lastVisitedString: "test"
            )
            viewModel.recentActivities = [cell]
        }
        let view = RecentActivityWidget(viewModel: viewModel)
        return HostingViewController(rootView: view)
    }
}


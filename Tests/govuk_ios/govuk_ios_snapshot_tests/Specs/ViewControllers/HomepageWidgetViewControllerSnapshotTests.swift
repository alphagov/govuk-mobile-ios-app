import Foundation
import XCTest
import GOVKit
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class HomepageWidgetViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController() -> UIViewController {
        let viewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: {_ in},
            allTopicsAction: {}
        )
        let view = HomepageWidget(content: TopicsWidget(viewModel: viewModel))
        return HostingViewController(rootView: view)
    }
}



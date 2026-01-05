import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class HomepageWidgetSnapshotTests: SnapshotTestCase {

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
            dismissEditAction: { }
        )
        let view = HomepageWidget(
            content: TopicsWidgetView(
            viewModel: viewModel
            )
        ).frame(width: 400,height: 250)
        return HostingViewController(rootView: view)
    }
}



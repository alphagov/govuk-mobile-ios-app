import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class HomepageWidgetViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_favouriteTopicsTabSelected_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(topicScreen: .favorite),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_favouriteTopicsTabSelected_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(
                topicScreen: .favorite
            ),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_AllTopicsTabSelected_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(
                topicScreen: .all
            ),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_AllTopicsTabSelected_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(
                topicScreen: .all
            ),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController(topicScreen: TopicSegment) -> UIViewController {
        let viewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: {_ in},
            dismissEditAction: { }
        )

        viewModel.setTopic(topic: topicScreen)
        let view = HomepageWidget(
            content: TopicsWidget(
            viewModel: viewModel
            )
        ).frame(width: 400,height: 250)

        return HostingViewController(rootView: view)
    }
}



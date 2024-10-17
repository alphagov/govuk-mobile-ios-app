import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
final class AllTopicsViewControllerSnapshotTests: SnapshotTestCase {

    private let mockTopicsService = MockTopicsService()

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark
        )
    }

    private func viewController() -> UIViewController {
        let topics = MockTopicsService().fetchAllTopics()
        let viewModel = AllTopicsViewModel(
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            topics: topics
        )
        let viewController = AllTopicsViewController(
            viewModel: viewModel
        )

        return viewController
    }
}

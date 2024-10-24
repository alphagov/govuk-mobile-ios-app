import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
final class TopicOnboardingViewControllerSnapshotTests: SnapshotTestCase {

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
        let analyticsService = MockAnalyticsService()
        let viewModel = TopicOnboardingViewModel(
            analyticsService: analyticsService,
            topicsService: MockTopicsService(),
            dismissAction: {}
        )
        let viewController = TopicOnboardingViewController(
            viewModel: viewModel
        )
        return viewController
    }
}

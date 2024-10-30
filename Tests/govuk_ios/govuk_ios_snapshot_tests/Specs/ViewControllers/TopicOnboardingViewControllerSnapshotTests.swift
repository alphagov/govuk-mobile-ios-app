import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
final class TopicOnboardingViewControllerSnapshotTests: SnapshotTestCase {

    private let mockTopicsService = MockTopicsService()
    let coreData = CoreDataRepository.arrangeAndLoad

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
        let topicService = MockTopicsService()
        let topics = Topic.arrangeMultiple(context: coreData.backgroundContext)
        topicService._stubbedFetchAllTopics = topics

        let viewModel = TopicOnboardingViewModel(
            analyticsService: analyticsService,
            topicsService: topicService,
            dismissAction: {}
        )
        let viewController = TopicOnboardingViewController(
            viewModel: viewModel
        )
        return viewController
    }
}

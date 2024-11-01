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
        let analyticsService = MockAnalyticsService()
        let mockTopicService = MockTopicsService()
        let topics = Topic.arrangeMultiple(context: coreData.viewContext)
        mockTopicService._stubbedFetchAllTopics = topics

        let viewModel = TopicOnboardingViewModel(
            analyticsService: analyticsService,
            topicsService: mockTopicService,
            dismissAction: {}
        )
        let viewController = TopicOnboardingViewController(
            viewModel: viewModel
        )
        viewController.beginAppearanceTransition(true, animated: false)
        viewController.endAppearanceTransition()
        return viewController
    }
}

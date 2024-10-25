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

        let topicOne = Topic(context: coreData.backgroundContext)
        topicOne.isFavorite = true
        topicOne.ref = "benefits"
        topicOne.title = "benefits"
        let topicTwo = Topic(context: coreData.backgroundContext)
        topicTwo.isFavorite = true
        topicTwo.ref = "benefits"
        topicTwo.title = "benefits"
        topicService._stubbedFetchAllTopics = [topicOne, topicTwo]

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


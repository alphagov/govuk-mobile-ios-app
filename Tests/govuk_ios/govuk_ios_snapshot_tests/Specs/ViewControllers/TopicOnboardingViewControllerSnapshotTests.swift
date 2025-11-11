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
            view: view,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            view: view,
            mode: .dark
        )
    }

    private var view: TopicsOnboardingView {
        let analyticsService = MockAnalyticsService()
        let mockTopicService = MockTopicsService()
        let topics = Topic.arrangeMultiple(context: coreData.viewContext)
        mockTopicService._stubbedFetchAllTopics = topics

        let viewModel = TopicsOnboardingViewModel(
            topics: topics,
            analyticsService: analyticsService,
            topicsService: mockTopicService,
            dismissAction: {}
        )
        let view = TopicsOnboardingView(
            viewModel: viewModel
        )
        return view
    }
}

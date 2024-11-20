import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class HomeViewControllerSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()

    func test_loadInNavigationController_light_rendersCorrectly() {
        mockTopicService._stubbedHasCustomisedTopics = true
        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
        var topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )

        mockTopicService._stubbedFetchAllTopics = topics

        topics.removeLast()
        mockTopicService._stubbedFetchFavouriteTopics = topics

        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
        let topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        mockTopicService._stubbedFetchAllTopics = topics
        mockTopicService._stubbedFetchFavouriteTopics = topics

        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            navBarHidden: true
        )
    }

    func viewController() -> HomeViewController {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            searchAction: { },
            recentActivityAction: { }
        )
        return HomeViewController(viewModel: viewModel)
    }
}

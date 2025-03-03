import Foundation
import XCTest
import UIKit
import GOVKit
@testable import govuk_ios

@MainActor
class HomeViewControllerSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad
    let mockTopicService = MockTopicsService()
    let mockAnalyticsService = MockAnalyticsService()

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

    func test_loadInNavigationController_notCusomised_rendersCorrectly() {
        mockTopicService._stubbedHasCustomisedTopics = false
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

    func test_loadInNavigationController_topicsError_rendersCorrectly() {
        mockTopicService._stubbedHasCustomisedTopics = false
        mockTopicService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_topicsError_dark_rendersCorrectly() {
        mockTopicService._stubbedHasCustomisedTopics = false
        mockTopicService._stubbedFetchRemoteListResult = .failure(.apiUnavailable)
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_deselectedAllTopics_rendersCorrectly() {
        let topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        mockTopicService._stubbedFetchAllTopics = topics
        mockTopicService._stubbedHasCustomisedTopics = true
        mockTopicService._stubbedFetchFavouriteTopics = []
        mockTopicService._stubbedFetchRemoteListResult = .success([])

        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_deselectedAllTopics_dark_rendersCorrectly() {
        let topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        mockTopicService._stubbedFetchAllTopics = topics
        mockTopicService._stubbedHasCustomisedTopics = true
        mockTopicService._stubbedFetchFavouriteTopics = []
        mockTopicService._stubbedFetchRemoteListResult = .success([])

        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            navBarHidden: true
        )
    }

    func viewController() -> HomeViewController {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            widgetBuilder: WidgetBuilder(analytics: MockAnalyticsService(),
                                         configService: MockAppConfigService(),
                                         topicWidgetViewModel: topicsViewModel,
                                         feedbackAction: { },
                                         searchAction: { },
                                         recentActivityAction: { })
        )
        return HomeViewController(viewModel: viewModel)
    }
}

import Foundation
import XCTest
import UIKit

@testable import govuk_ios
@testable import GOVKitTestUtilities

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

    func test_loadInNavigationController_searchDisabled_rendersCorrectly() {
        mockTopicService._stubbedHasCustomisedTopics = true
        mockTopicService._stubbedFetchRemoteListResult = .success(TopicResponseItem.arrangeMultiple)
        var topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        let mockConfigService = MockAppConfigService()
        mockConfigService.features = [.onboarding, .topics, .recentActivity]

        mockTopicService._stubbedFetchAllTopics = topics

        topics.removeLast()
        mockTopicService._stubbedFetchFavouriteTopics = topics

        VerifySnapshotInNavigationController(
            viewController: viewController(configService: mockConfigService),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_searchBarShouldBeginEditing_rendersCorrectly() {
        let viewController = viewController()
        guard let searchBar: UISearchBar =
                viewController.view.subviews.first(where: { $0 is UISearchBar } ) as? UISearchBar
        else {
            return
        }
        let _ = viewController.searchBarShouldBeginEditing(searchBar)

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_searchEditing_resetState_rendersCorrectly() {
        let viewController = viewController()
        guard let searchBar: UISearchBar =
                viewController.view.subviews.first(where: { $0 is UISearchBar } ) as? UISearchBar
        else {
            return
        }
        let _ = viewController.searchBarShouldBeginEditing(searchBar)
        viewController.resetState()

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_searchEditing_cancelSearch_rendersCorrectly() {
        let viewController = viewController()
        guard let searchBar: UISearchBar =
                viewController.view.subviews.first(where: { $0 is UISearchBar } ) as? UISearchBar
        else {
            return
        }
        let _ = viewController.searchBarShouldBeginEditing(searchBar)
        viewController.searchBarCancelButtonClicked(searchBar)

        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func viewController(
        configService: MockAppConfigService = MockAppConfigService()
    ) -> HomeViewController {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: mockAnalyticsService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            recentActivityAction: { },
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService()
        )
        return HomeViewController(viewModel: viewModel)
    }
}

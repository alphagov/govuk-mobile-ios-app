import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class HomeViewControllerSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad
    let topicService = MockTopicsService()

    func test_loadInNavigationController_light_rendersCorrectly() {

        topicService._stubbedDownloadTopicsListResult = MockTopicsService.testTopicsResult

        var topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )

        topicService._stubbedFetchAllTopics = topics

        topics.removeLast()
        topicService._stubbedFetchFavoriteTopics = topics

        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        topicService._stubbedDownloadTopicsListResult = MockTopicsService.testTopicsResult
        let topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        topicService._stubbedFetchAllTopics = topics
        topicService._stubbedFetchFavoriteTopics = topics

        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            navBarHidden: true
        )
    }

    func viewController() -> HomeViewController {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: topicService,
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

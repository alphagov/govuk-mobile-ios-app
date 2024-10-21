import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class HomeViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(allTopicsFavourited: false),
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(allTopicsFavourited: true),
            mode: .dark,
            navBarHidden: true
        )
    }

    func viewController(allTopicsFavourited: Bool) -> HomeViewController {
        let topicService = MockTopicsService()
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult
        topicService._allTopicsFavourited = allTopicsFavourited
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: topicService,
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { })
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

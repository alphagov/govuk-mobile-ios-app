import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
class HomeViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            navBarHidden: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            navBarHidden: true
        )
    }

    private var viewController: HomeViewController {
        let topicService = MockTopicsService()
        topicService._receivedFetchTopicsResult = MockTopicsService.testTopicsResult
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: topicService,
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            editAction: { _ in },
            allTopicsAction: { _ in })
        let viewModel = HomeViewModel(
            configService: MockAppConfigService(),
            searchButtonPrimaryAction: { },
            recentActivityAction: { },
            topicWidgetViewModel: topicsViewModel
        )
        return HomeViewController(viewModel: viewModel)
    }
}

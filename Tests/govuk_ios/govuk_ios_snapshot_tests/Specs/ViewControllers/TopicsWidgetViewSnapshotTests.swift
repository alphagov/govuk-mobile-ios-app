import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class TopicWidgetViewSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad

    func test_loadInNavigationController_populated_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_populated_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController() -> UIViewController {

        let mockTopicService = MockTopicsService()
        let favouriteOne = Topic.arrange(
            context: coreData.backgroundContext
        )
        favouriteOne.title = "test"
        mockTopicService._stubbedHasCustomisedTopics = true
        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne]

        let viewModel = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            dismissEditAction: { }
        )
        let view = TopicsWidget(
            viewModel: viewModel
        )
        return HostingViewController(rootView: view)
    }
}


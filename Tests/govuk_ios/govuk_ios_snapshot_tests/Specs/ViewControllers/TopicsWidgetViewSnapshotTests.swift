import Foundation
import XCTest
import GOVKit
import UIKit

@testable import govuk_ios

@MainActor
final class TopicsWidgetViewSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad

    func test_loadInNavigationController_populated_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(topicScreen: .favourite),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_populated_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(topicScreen: .favourite),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_populated_allTopics_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(topicScreen: .all),
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_populated_allTopics_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(topicScreen: .all),
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private func viewController(topicScreen: TopicSegment) -> UIViewController {

        let mockTopicService = MockTopicsService()
        let favouriteOne = Topic.arrange(
            context: coreData.backgroundContext
        )
        favouriteOne.title = "test"
        mockTopicService._stubbedHasCustomisedTopics = true
        let allOne = Topic.arrange(context: coreData.backgroundContext)
        let allTwo = Topic.arrange(context: coreData.backgroundContext)
        allOne.title = "test2"
        allTwo.title = "test3"

        mockTopicService._stubbedFetchFavouriteTopics = [favouriteOne]
        mockTopicService._stubbedFetchAllTopics = [allOne, allTwo, favouriteOne]

        let viewModel = TopicsWidgetViewModel(
            topicsService: mockTopicService,
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            dismissEditAction: { }
        )
        viewModel.topicsScreen = topicScreen

        let view = TopicsWidgetView(
            viewModel: viewModel
        )
        return HostingViewController(
            rootView: view
        )
    }
}


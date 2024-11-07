import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
final class EditTopicsViewControllerSnapshotTests: SnapshotTestCase {
    
    private let mockTopicsService = MockTopicsService()

    func test_loadInNavigationController_light_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        let viewController = viewController(
            topics: topics,
            personalised: true
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topics = Topic.arrangeMultipleFavourites(
            context: coreData.viewContext
        )
        let viewController = viewController(
            topics: topics,
            personalised: true
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark
        )
    }

    func test_loadInNavigationController_noFavourites_notPersonalised_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topics = [
            Topic.arrange(
                context: coreData.viewContext,
                title: "Topic 1",
                isFavourite: false
            ),
            Topic.arrange(
                context: coreData.viewContext,
                title: "Topic 2",
                isFavourite: false
            ),
            Topic.arrange(
                context: coreData.viewContext,
                title: "Topic 3",
                isFavourite: false
            )
        ]
        let viewController = viewController(
            topics: topics,
            personalised: false
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    func test_loadInNavigationController_noFavourites_personalised_rendersCorrectly() {
        let coreData = CoreDataRepository.arrangeAndLoad
        let topics = [
            Topic.arrange(
                context: coreData.viewContext,
                title: "Topic 1",
                isFavourite: false
            ),
            Topic.arrange(
                context: coreData.viewContext,
                title: "Topic 2",
                isFavourite: false
            ),
            Topic.arrange(
                context: coreData.viewContext,
                title: "Topic 3",
                isFavourite: false
            )
        ]
        let viewController = viewController(
            topics: topics,
            personalised: true
        )
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light
        )
    }

    private func viewController(topics: [Topic],
                                personalised: Bool) -> UIViewController {
        mockTopicsService._stubbedFetchAllTopics = topics
        mockTopicsService._stubbedHasPersonalisedTopics = personalised
        let viewModel = EditTopicsViewModel(
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService(),
            dismissAction: { }
        )
        let view = EditTopicsView(
            viewModel: viewModel
        )
        
        return HostingViewController(rootView: view)
    }
}

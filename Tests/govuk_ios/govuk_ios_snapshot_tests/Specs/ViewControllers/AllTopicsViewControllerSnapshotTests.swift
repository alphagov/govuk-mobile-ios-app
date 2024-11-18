import Foundation
import XCTest
import UIKit

@testable import govuk_ios

@MainActor
final class AllTopicsViewControllerSnapshotTests: SnapshotTestCase {

    private let mockTopicsService = MockTopicsService()
    private let coreData = CoreDataRepository.arrangeAndLoad

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .light
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController(),
            mode: .dark
        )
    }

    private func viewController() -> UIViewController {
        let topicsService = MockTopicsService()
        topicsService._stubbedFetchAllTopics = createTopics()
        try? topicsService.coreData.viewContext.save()

        let viewModel = AllTopicsViewModel(
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            topicsService: topicsService
        )
        let viewController = AllTopicsViewController(
            viewModel: viewModel
        )

        return viewController
    }

    private func createTopics() -> [Topic] {
        var topics = [Topic]()
        for index in 0..<3 {
            let topic = Topic(context: coreData.viewContext)
            topic.ref = "ref\(index)"
            topic.title = "title\(index)"
            topic.isFavourite = false
            topics.append(topic)
        }
        return topics
    }
}

import Foundation
import XCTest
import GOVKit

@testable import govuk_ios

@MainActor
final class EditTopicsViewSnapshotTests: SnapshotTestCase {
    let coreData = CoreDataRepository.arrangeAndLoad

    func test_loadInNavigationController_light_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .light,
            prefersLargeTitles: true
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        VerifySnapshotInNavigationController(
            viewController: viewController,
            mode: .dark,
            prefersLargeTitles: true
        )
    }

    private var viewController: UIViewController {
        let mockTopicsService = MockTopicsService()
        mockTopicsService._stubbedFetchAllTopics = createTopics()
        try? mockTopicsService.coreData.viewContext.save()
        let editTopicsViewModel = EditTopicsViewModel(
            topicsService: mockTopicsService,
            analyticsService: MockAnalyticsService()
        )
        let editTopicsView = EditTopicsView(
            viewModel: editTopicsViewModel
        )
        return HostingViewController(rootView: editTopicsView)
    }

    private func createTopics() -> [Topic] {
        var topics = [Topic]()
        for index in 1...4 {
            let topic = Topic(context: coreData.viewContext)
            topic.ref = "ref\(index)"
            topic.title = "title\(index)"
            topic.isFavourite = index.isMultiple(of: 2) ? true : false
            topics.append(topic)
        }
        return topics
    }
}



import Foundation
import XCTest
import CoreData
import UIComponents

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class SearchHistoryViewControllerSnapshotTests: SnapshotTestCase {

    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockSearchService = arrangeSearchService()
        let mockAnalyticsService = MockAnalyticsService()

        let viewModel = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )
        let viewController = SearchHistoryViewController(
            viewModel: viewModel,
            accessibilityAnnouncer: MockAccessibilityAnnouncerService(),
            selectionAction: { _ in }
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .light
        VerifySnapshotInWindow(
            navigationController
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let mockSearchService = arrangeSearchService()
        let mockAnalyticsService = MockAnalyticsService()

        let viewModel = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )
        let viewController = SearchHistoryViewController(
            viewModel: viewModel,
            accessibilityAnnouncer: MockAccessibilityAnnouncerService(),
            selectionAction: { _ in }
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .dark
        VerifySnapshotInWindow(
            navigationController
        )
    }

    private func arrangeSearchService() -> SearchServiceInterface {
        let service = MockSearchService()
        let coreData = CoreDataRepository.arrangeAndLoad
        let item = SearchHistoryItem(context: coreData.viewContext)
        item.searchText = "Test search"
        item.date = Date()
        try! coreData.viewContext.save()

        let fetchRequest = SearchHistoryItem.fetchRequest()
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? controller.performFetch()
        service._stubbedFetchResultsController = controller
        return service
    }

}

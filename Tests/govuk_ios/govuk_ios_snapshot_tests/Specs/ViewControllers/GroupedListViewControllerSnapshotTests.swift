import Foundation
import XCTest
import CoreData

@testable import govuk_ios

@MainActor
final class GroupedListViewControllerSnapshotTests: SnapshotTestCase {
    func test_loadInNavigationController_light_rendersCorrectly() {
        let mockActivityService = MockActivityService()
        let coreData = CoreDataRepository.arrangeAndLoad
        _ = ActivityItem.arrange(
            title: "Test 1",
            date: .arrange("01/10/2023"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 2",
            date: .arrange("02/02/2024"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 3",
            date: .arrange("10/04/2024"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 4",
            date: .arrange("11/04/2024"),
            context: coreData.viewContext
        )
        let request = ActivityItem.fetchRequest()
        let resultsController = NSFetchedResultsController<ActivityItem>(
            fetchRequest: request,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.fetch()
        mockActivityService._stubbedFetchResultsController = resultsController

        let viewController = GroupedListViewController(
            viewModel: .init(
                activityService: mockActivityService,
                analyticsService: MockAnalyticsService(),
                urlopener: MockURLOpener()
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .light
        VerifySnapshotInWindow(
            navigationController
        )
    }

    func test_loadInNavigationController_dark_rendersCorrectly() {
        let mockActivityService = MockActivityService()
        let coreData = CoreDataRepository.arrangeAndLoad
        _ = ActivityItem.arrange(
            title: "Test 5",
            date: .arrange("21/12/2024"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 1",
            date: .arrange("01/10/2023"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 2",
            date: .arrange("02/02/2024"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 3",
            date: .arrange("10/04/2024"),
            context: coreData.viewContext
        )
        _ = ActivityItem.arrange(
            title: "Test 4",
            date: .arrange("11/04/2024"),
            context: coreData.viewContext
        )
        let request = ActivityItem.fetchRequest()
        let resultsController = NSFetchedResultsController<ActivityItem>(
            fetchRequest: request,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.fetch()
        mockActivityService._stubbedFetchResultsController = resultsController

        let viewController = GroupedListViewController(
            viewModel: .init(
                activityService: mockActivityService,
                analyticsService: MockAnalyticsService(),
                urlopener: MockURLOpener()
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .dark
        VerifySnapshotInWindow(
            navigationController
        )
    }
}


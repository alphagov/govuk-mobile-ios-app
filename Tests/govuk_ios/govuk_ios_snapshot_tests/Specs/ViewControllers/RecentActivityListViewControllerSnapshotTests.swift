import Foundation
import XCTest
import CoreData
import RecentActivity

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
final class RecentActivityListViewControllerSnapshotTests: SnapshotTestCase {
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

        let viewController = RecentActivityListViewController(
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
            date: .arrange("21/11/2024"),
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

        let viewController = RecentActivityListViewController(
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

    func test_loadInNavigationController_editing_rendersCorrectly() {
        let mockActivityService = MockActivityService()
        let coreData = CoreDataRepository.arrangeAndLoad
        _ = ActivityItem.arrange(
            title: "Test 5",
            date: .arrange("21/11/2024"),
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

        let viewController = RecentActivityListViewController(
            viewModel: .init(
                activityService: mockActivityService,
                analyticsService: MockAnalyticsService(),
                urlopener: MockURLOpener()
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .light

        viewController.setEditing(true, animated: false)

        let tableview = viewController.view.subviews.compactMap { $0 as? UITableView }.first!
        tableview.selectAllRows(animated: false)

        tableview.deselectAllRows(animated: false)
        let index = IndexPath(item: 0, section: 0)
        tableview.selectRow(at: index, animated: false, scrollPosition: .none)
        viewController.tableView(tableview, didSelectRowAt: index)

        VerifySnapshotInWindow(
            navigationController
        )
    }

    func test_loadInNavigationController_editing_allSelected_rendersCorrectly() {
        let mockActivityService = MockActivityService()
        let coreData = CoreDataRepository.arrangeAndLoad
        _ = ActivityItem.arrange(
            title: "Test 1",
            date: .arrange("21/11/2024"),
            context: coreData.viewContext
        )

        _ = ActivityItem.arrange(
            title: "Test 2",
            date: .arrange("10/01/2023"),
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

        let viewController = RecentActivityListViewController(
            viewModel: .init(
                activityService: mockActivityService,
                analyticsService: MockAnalyticsService(),
                urlopener: MockURLOpener()
            )
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.overrideUserInterfaceStyle = .light

        viewController.setEditing(true, animated: false)

        let tableview = viewController.view.subviews.compactMap { $0 as? UITableView }.first!
        tableview.selectAllRows(animated: false)

        VerifySnapshotInWindow(
            navigationController
        )
    }
}


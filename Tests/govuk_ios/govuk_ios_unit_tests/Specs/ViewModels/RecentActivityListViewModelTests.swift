import Foundation
import Testing
import CoreData
import GOVKit

@testable import govuk_ios

@Suite
struct RecentActivityListViewModelTests {

    @Test
    func pageTitle_returnsExpectedResult() {
        let sut = RecentActivityListViewModel(
            activityService: MockActivityService(),
            analyticsService: MockAnalyticsService(),
            selectedAction: { _ in }
        )

        #expect(
            sut.pageTitle == String.recentActivity.localized("recentActivityNavigationTitle")
        )
    }

    @Test
    func selectItem_validURL_performsExpectedActions() {
        let mockService = MockActivityService()
        let mockAnalyticsService = MockAnalyticsService()
        var receivedURL: URL?
        let sut = RecentActivityListViewModel(
            activityService: mockService,
            analyticsService: mockAnalyticsService,
            selectedAction: { url in
                receivedURL = url
            }
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let item = ActivityItem.arrange(
            date: .arrange("01/01/2001"),
            context: coreData.viewContext
        )

        sut.selected(item: item)

        #expect(receivedURL?.absoluteString == item.url)
        let expectedEvent = AppEvent.recentActivityNavigation(activity: item)
        #expect(mockAnalyticsService._trackedEvents.first?.name == expectedEvent.name)
        #expect(
            Calendar.current.isDate(item.date, equalTo: Date(), toGranularity: .minute)
        )
    }

    @Test
    func selectItem_invalidURL_callsService() {
        let mockService = MockActivityService()
        let mockAnalyticsService = MockAnalyticsService()
        var receivedURL: URL?
        let sut = RecentActivityListViewModel(
            activityService: mockService,
            analyticsService: mockAnalyticsService,
            selectedAction: { url in
                receivedURL = url
            }
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let item = ActivityItem.arrange(
            url: "",
            context: coreData.viewContext
        )

        sut.selected(item: item)

        #expect(receivedURL == nil)
        #expect(mockAnalyticsService._trackedEvents.isEmpty)
    }

    @Test
    func editItem_confirmDelete_removesExpectedItems() {
        let mockActivityService = MockActivityService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockActivityService,
            analyticsService: mockAnalyticsService,
            selectedAction: { _ in }
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let item1 = ActivityItem.arrange(
            context: coreData.viewContext
        )

        let item2 = ActivityItem.arrange(
            context: coreData.viewContext
        )

        sut.edit(item: item1)
        // Simulate somehow selecting same object twice should only pass the id once
        sut.edit(item: item1)
        sut.edit(item: item2)

        sut.removeEdit(item: item2)

        sut.confirmDeletionOfEditingItems()

        #expect(mockActivityService._receivedDeleteObjectIds?.count == 1)
        #expect(mockActivityService._receivedDeleteObjectIds?.first == item1.objectID)
    }

    @Test
    @MainActor
    func editItem_endEditing_removesSelectedItems() {
        let mockActivityService = MockActivityService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockActivityService,
            analyticsService: mockAnalyticsService,
            selectedAction: { _ in }
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let item1 = ActivityItem.arrange(
            context: coreData.viewContext
        )

        let item2 = ActivityItem.arrange(
            context: coreData.viewContext
        )

        sut.edit(item: item1)
        sut.edit(item: item2)

        sut.endEditing()

        sut.confirmDeletionOfEditingItems()

        #expect(mockActivityService._receivedDeleteObjectIds == nil)
    }

    @Test
    @MainActor
    func isEveryItemSelected_everyItemSelected_returnsTrue() {
        let mockActivityService = MockActivityService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockActivityService,
            analyticsService: mockAnalyticsService,
            selectedAction: { _ in }
        )

        let coreData = CoreDataRepository.arrangeAndLoad
        let item1 = ActivityItem.arrange(
            context: coreData.viewContext
        )

        let item2 = ActivityItem.arrange(
            context: coreData.viewContext
        )

        let request = ActivityItem.fetchRequest()
        let resultsController = NSFetchedResultsController<ActivityItem>(
            fetchRequest: request,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? resultsController.performFetch()
        mockActivityService._stubbedFetchResultsController = resultsController

        sut.fetchActivities()

        sut.edit(item: item1)
        sut.edit(item: item2)

        #expect(sut.isEveryItemSelected() == true)
    }

    @Test
    @MainActor
    func isEveryItemSelected_noItemsSelected_returnsFalse() {
        let mockActivityService = MockActivityService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockActivityService,
            analyticsService: mockAnalyticsService,
            selectedAction: { _ in }
        )

        let coreData = CoreDataRepository.arrangeAndLoad
        _ = ActivityItem.arrange(
            context: coreData.viewContext
        )

        _ = ActivityItem.arrange(
            context: coreData.viewContext
        )

        let request = ActivityItem.fetchRequest()
        let resultsController = NSFetchedResultsController<ActivityItem>(
            fetchRequest: request,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? resultsController.performFetch()
        mockActivityService._stubbedFetchResultsController = resultsController

        sut.fetchActivities()

        #expect(sut.isEveryItemSelected() == false)
    }
}

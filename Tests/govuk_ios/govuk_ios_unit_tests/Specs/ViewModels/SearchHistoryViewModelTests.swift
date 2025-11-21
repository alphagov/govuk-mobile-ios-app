import Testing
import Foundation
import UIKit
import CoreData

@testable import govuk_ios

@MainActor
struct SearchHistoryViewModelTests {

    @Test
    func init_fetches_searchHistoryItems_from_searchService() throws {

        let coreData = CoreDataRepository.arrangeAndLoad
        let item = SearchHistoryItem(context: coreData.viewContext)
        item.searchText = UUID().uuidString
        item.date = Date()
        try! coreData.viewContext.save()

        let fetchRequest = SearchHistoryItem.fetchRequest()
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try controller.performFetch()

        let mockSearchService = MockSearchService()
        mockSearchService._stubbedFetchResultsController = controller
        let mockAnalyticsService = MockAnalyticsService()
        let sut = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )
        #expect(sut.searchHistoryItems.count == 1)
    }

    @Test
    func save_calls_save_on_searchService() {
        let mockSearchService = MockSearchService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )

        sut.saveSearchHistoryItem(
            searchText: UUID().uuidString,
            date: Date()
        )
        #expect(mockSearchService._didCallSaveSearchHistory)
    }

    @Test
    func clearSearchHistory_calls_clear_on_searchService() {
        let mockSearchService = MockSearchService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )

        sut.clearSearchHistory()
        #expect(mockSearchService._didCallClearSearchHistory)
    }

    @Test
    func delete_calls_delete_on_searchService() {
        let mockSearchService = MockSearchService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )

        let coreData = CoreDataRepository.arrangeAndLoad
        let item = SearchHistoryItem(context: coreData.viewContext)
        sut.delete(item)
        #expect(mockSearchService._didCallDeleteSearchHistoryItem)
    }

    @Test
    @MainActor
    func historyItemForObjectId_notFound_logsError() {
        let mockSearchService = MockSearchService()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = SearchHistoryViewModel(
            searchService: mockSearchService,
            analyticsService: mockAnalyticsService
        )

        let coreData = CoreDataRepository.arrangeAndLoad
        let item = SearchHistoryItem(context: coreData.viewContext)
        let expectedId: NSManagedObjectID = item.objectID.copy() as! NSManagedObjectID

        coreData.viewContext.delete(item)
        try? coreData.viewContext.save()

        let request = SearchHistoryItem.fetchRequest()
        let resultsController = NSFetchedResultsController<SearchHistoryItem>(
            fetchRequest: request,
            managedObjectContext: coreData.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        mockSearchService._stubbedFetchResultsController = resultsController

        let foundItem = sut.historyItem(for: expectedId)
        #expect(foundItem == nil)
        #expect(mockAnalyticsService._trackErrorReceivedErrors.count == 1)
    }
}


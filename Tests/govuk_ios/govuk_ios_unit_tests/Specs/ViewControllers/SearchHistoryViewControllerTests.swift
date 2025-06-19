import Foundation
import Testing
import GOVKit
import CoreData

@testable import govuk_ios

@Suite
struct SearchHistoryViewControllerTest {

    @Test
    func announce_noPreviousSearches_doesntAnnounce() {
        let mockAccessibilityAnnouncerService = MockAccessibilityAnnouncerService()
        let viewModel = MockSearchHistoryViewModel()
        viewModel._stubbedSearchHistoryItems = []
        let sut = SearchHistoryViewController(
            viewModel: viewModel,
            accessibilityAnnouncer: mockAccessibilityAnnouncerService,
            selectionAction: { _ in }
        )

        sut.announce()

        #expect(mockAccessibilityAnnouncerService._receivedAnnounceValue == nil)
    }

    @Test
    func announce_previousSearches_announces() {
        let mockAccessibilityAnnouncerService = MockAccessibilityAnnouncerService()
        let service = arrangeSearchService()
        let viewModel = SearchHistoryViewModel(
            searchService: service,
            analyticsService: MockAnalyticsService()
        )
        let sut = SearchHistoryViewController(
            viewModel: viewModel,
            accessibilityAnnouncer: mockAccessibilityAnnouncerService,
            selectionAction: { _ in }
        )

        sut.announce()

        #expect(mockAccessibilityAnnouncerService._receivedAnnounceValue != nil)
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

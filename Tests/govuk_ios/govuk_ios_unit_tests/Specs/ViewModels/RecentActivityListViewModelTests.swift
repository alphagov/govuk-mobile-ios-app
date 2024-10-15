import Foundation
import Testing

@testable import govuk_ios

@Suite
struct RecentActivityListViewModelTests {

    @Test
    func pageTitle_returnsExpectedResult() {
        let sut = RecentActivityListViewModel(
            activityService: MockActivityService(),
            analyticsService: MockAnalyticsService(),
            urlopener: MockURLOpener()
        )

        #expect(
            sut.pageTitle == String.recentActivity.localized("recentActivityNavigationTitle")
        )
    }

    @Test
    func selectItem_validURL_performsExpectedActions() {
        let mockService = MockActivityService()
        let mockURLOpener = MockURLOpener()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockService,
            analyticsService: mockAnalyticsService,
            urlopener: mockURLOpener
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let item = ActivityItem.arrange(
            date: .arrange("01/01/2001"),
            context: coreData.viewContext
        )

        sut.selected(item: item)

        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == item.url)
        let expectedEvent = AppEvent.recentActivity(activity: item)
        #expect(mockAnalyticsService._trackedEvents.first?.name == expectedEvent.name)
        #expect(
            Calendar.current.isDate(item.date, equalTo: Date(), toGranularity: .minute)
        )
    }

    @Test
    func selectItem_invalidURL_callsService() {
        let mockService = MockActivityService()
        let mockURLOpener = MockURLOpener()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockService,
            analyticsService: mockAnalyticsService,
            urlopener: mockURLOpener
        )
        let coreData = CoreDataRepository.arrangeAndLoad
        let item = ActivityItem.arrange(
            url: "",
            context: coreData.viewContext
        )

        sut.selected(item: item)

        #expect(mockURLOpener._receivedOpenIfPossibleUrlString == nil)
        #expect(mockAnalyticsService._trackedEvents.isEmpty)
    }

    @Test
    func editItem_confirmDelete_removesExpectedItems() {
        let mockActivityService = MockActivityService()
        let mockURLOpener = MockURLOpener()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockActivityService,
            analyticsService: mockAnalyticsService,
            urlopener: mockURLOpener
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
        let mockURLOpener = MockURLOpener()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = RecentActivityListViewModel(
            activityService: mockActivityService,
            analyticsService: mockAnalyticsService,
            urlopener: mockURLOpener
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
}

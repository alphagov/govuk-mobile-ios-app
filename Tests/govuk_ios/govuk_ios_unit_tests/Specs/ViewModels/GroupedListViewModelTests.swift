import Foundation
import Testing

@testable import govuk_ios

@Suite
struct GroupedListViewModelTests {

    @Test
    func pageTitle_returnsExpectedResult() {
        let sut = GroupedListViewModel(
            activityService: MockActivityService(),
            analyticsService: MockAnalyticsService(),
            urlopener: MockURLOpener()
        )

        #expect(
            sut.pageTitle == String.recentActivity.localized("recentActivityNavigationTitle")
        )
    }

    @Test
    func deleteAll_callsService() {
        let mockService = MockActivityService()
        let sut = GroupedListViewModel(
            activityService: mockService,
            analyticsService: MockAnalyticsService(),
            urlopener: MockURLOpener()
        )

        sut.deleteAllItems()

        #expect(mockService._receivedDeleteAll)
    }

    @Test
    func selectItem_validURL_performsExpectedActions() {
        let mockService = MockActivityService()
        let mockURLOpener = MockURLOpener()
        let mockAnalyticsService = MockAnalyticsService()
        let sut = GroupedListViewModel(
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
        let sut = GroupedListViewModel(
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
}

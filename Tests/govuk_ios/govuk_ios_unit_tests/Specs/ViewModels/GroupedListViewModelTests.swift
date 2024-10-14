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

}

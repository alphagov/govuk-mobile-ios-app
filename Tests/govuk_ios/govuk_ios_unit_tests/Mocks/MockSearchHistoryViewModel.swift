import Foundation
import GOVKit

@testable import govuk_ios

class MockSearchHistoryViewModel: SearchHistoryViewModelInterface {
    var analyticsService: AnalyticsServiceInterface {
        MockAnalyticsService()
    }

    var _stubbedSearchHistoryItems: [SearchHistoryItem] = []
    var searchHistoryItems: [SearchHistoryItem] {
        _stubbedSearchHistoryItems
    }

    func saveSearchHistoryItem(searchText: String,
                               date: Date) {

    }

    func clearSearchHistory() {

    }

    func delete(_ item: SearchHistoryItem) {

    }
}

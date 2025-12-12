import Foundation
import CoreData
import GOVKit

@testable import govuk_ios

class MockSearchHistoryViewModel: SearchHistoryViewModelInterface {
    var analyticsService: AnalyticsServiceInterface {
        MockAnalyticsService()
    }

    var _stubbedSearchHistoryItems: [NSManagedObjectID] = []
    var searchHistoryItems: [NSManagedObjectID] {
        _stubbedSearchHistoryItems
    }

    func saveSearchHistoryItem(searchText: String,
                               date: Date) {

    }

    func clearSearchHistory() {

    }

    func delete(_ item: SearchHistoryItem) {

    }

    func historyItem(for objectId: NSManagedObjectID) -> SearchHistoryItem? {
        nil
    }
}

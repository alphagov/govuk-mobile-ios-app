import Foundation
import CoreData

@testable import govuk_ios

class MockSearchHistoryRepository: SearchHistoryRepositoryInterface {
    
    var _didSaveSearchHistory: Bool = false
    func save(searchText: String, date: Date) {
        _didSaveSearchHistory = true
    }
    
    var _didClearSearcchHistory: Bool = false
    func clearSearchHistory() {
        _didClearSearcchHistory = true
    }
    
    var _stubbedFetchResultsController: NSFetchedResultsController<SearchHistoryItem>!
    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem> {
        _stubbedFetchResultsController
    }
    
}

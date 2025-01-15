import Foundation
import CoreData

@testable import govuk_ios

class MockSearchService: SearchServiceInterface {
    var _didCallDeleteSearchHistoryItem: Bool = false
    func delete(_ item: SearchHistoryItem) {
        _didCallDeleteSearchHistoryItem = true
    }
    
    var _didCallSaveSearchHistory: Bool = false
    func save(searchText: String, date: Date) {
        _didCallSaveSearchHistory = true
    }
    
    var _didCallClearSearchHistory: Bool = false
    func clearSearchHistory() {
        _didCallClearSearchHistory = true
    }
    
    var _stubbedFetchResultsController: NSFetchedResultsController<SearchHistoryItem>?
    var fetchedResultsController: NSFetchedResultsController<SearchHistoryItem>? {
        _stubbedFetchResultsController
    }
    
    var _searchReceivedTerm: String?
    var _stubbedSearchResult: Result<SearchResult, SearchError>?
    var _searchReceivedCompletion: ((Result<SearchResult, SearchError>) -> Void)?
    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        _searchReceivedTerm = term
        _searchReceivedCompletion = completion
        if let result = _stubbedSearchResult {
            completion(result)
        }
    }
}

import Foundation

@testable import govuk_ios

class MockSearchService: SearchServiceInterface {    
    var _searchReceivedTerm: String?
    var _searchReceivedCompletion: ((Result<SearchResult, SearchError>) -> Void)?
    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        _searchReceivedTerm = term
        _searchReceivedCompletion = completion
    }
}

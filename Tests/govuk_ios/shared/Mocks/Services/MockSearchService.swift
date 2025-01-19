import Foundation

@testable import govuk_ios

class MockSearchService: SearchServiceInterface {
    var _suggestionsReceivedTerm: String?
    var _stubbedSuggestions: [String]?
    var _suggestionsReceivedCompletion: (([String]) -> Void)?
    func suggestions(_ term: String,
                     completion: @escaping ([String]) -> Void) {
        _suggestionsReceivedTerm = term
        _suggestionsReceivedCompletion = completion
        if let result = _stubbedSuggestions {
            completion(result)
        }
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

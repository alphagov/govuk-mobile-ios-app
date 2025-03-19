import Foundation

@testable import govuk_ios

class MockSearchServiceClient: SearchServiceClientInterface {
    var _receivedTerm: String?
    var _receivedSuggestionsCompletion: ((Result<SearchSuggestions, SearchError>) -> Void)?
    var _stubbedSuggestionsResult: Result<SearchSuggestions, SearchError>?
    func suggestions(term: String,
                     completion: @escaping (Result<SearchSuggestions, SearchError>) -> Void) {
        _receivedTerm = term
        _receivedSuggestionsCompletion = completion
        if let result = _stubbedSuggestionsResult {
            completion(result)
        }
    }

    var _receivedSearchTerm: String?
    var _receivedSearchCompletion: ((Result<SearchResult, SearchError>) -> Void)?
    var _stubbedSearchResult: Result<SearchResult, SearchError>?
    func search(term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        _receivedSearchTerm = term
        _receivedSearchCompletion = completion
        if let result = _stubbedSearchResult {
            completion(result)
        }
    }
}

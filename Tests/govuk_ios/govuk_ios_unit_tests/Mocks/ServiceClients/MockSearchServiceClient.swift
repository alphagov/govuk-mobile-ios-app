import Foundation

@testable import govuk_ios

class MockSearchServiceClient: SearchServiceClientInterface {
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

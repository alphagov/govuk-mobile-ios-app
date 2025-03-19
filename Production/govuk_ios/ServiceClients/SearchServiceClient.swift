import Foundation

protocol SearchServiceClientInterface {
    func search(term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void)

    func suggestions(term: String,
                     completion: @escaping (Result<SearchSuggestions, SearchError>) -> Void)
}

class SearchServiceClient: SearchServiceClientInterface {
    private let serviceClient: APIServiceClientInterface
    private let suggestionsServiceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface,
         suggestionsServiceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
        self.suggestionsServiceClient = suggestionsServiceClient
    }

    func search(term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        let request = GOVRequest.search(
            term: term
        )
        serviceClient.send(
            request: request,
            completion: { [weak self] result in
                guard let mappedResult = self?.mapResult(result, decodable: SearchResult.self)
                else { return }

                completion(mappedResult)
            }
        )
    }

    func suggestions(term: String,
                     completion: @escaping (Result<SearchSuggestions, SearchError>) -> Void) {
        let request = GOVRequest.searchSuggestions(
            term: term
        )
        suggestionsServiceClient.send(
            request: request,
            completion: { [weak self] result in
                guard let mappedResult = self?.mapResult(result, decodable: SearchSuggestions.self)
                else { return }

                completion(mappedResult)
            }
        )
    }

    private func mapResult<T: Decodable>(
        _ result: NetworkResult<Data>,
        decodable: T.Type) -> Result<T, SearchError> {
        return result.mapError { error in
            let nsError = (error as NSError)
            if nsError.code == NSURLErrorNotConnectedToInternet {
                return SearchError.networkUnavailable
            } else {
                return SearchError.apiUnavailable
            }
        }.flatMap {
            do {
                let searchResult: T = try JSONDecoder().decode(from: $0)
                return .success(searchResult)
            } catch {
                return .failure(SearchError.parsingError)
            }
        }
    }
}

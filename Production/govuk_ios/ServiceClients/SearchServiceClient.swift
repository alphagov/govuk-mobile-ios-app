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
            completion: { result in
                let mappedResult = result.mapError { error in
                    let nsError = (error as NSError)
                    if nsError.code == NSURLErrorNotConnectedToInternet {
                        return SearchError.networkUnavailable
                    } else {
                        return SearchError.apiUnavailable
                    }
                }.flatMap {
                    do {
                        let searchResult: SearchResult = try JSONDecoder().decode(from: $0)
                        return .success(searchResult)
                    } catch {
                        return .failure(SearchError.parsingError)
                    }
                }

                completion(mappedResult)
            }
        )
    }
}

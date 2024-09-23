import Foundation

protocol SearchServiceClientInterface {
    func search(term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void)
}

class SearchServiceClient: SearchServiceClientInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func search(term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        serviceClient.send(
            request: .search(term: term),
            completion: { result in
                let mappedResult = result
                    .mapError { _ in SearchError.apiUnavailable }
                    .flatMap {
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
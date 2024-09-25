import Foundation

protocol SearchServiceInterface {
    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void)
}

class SearchService: SearchServiceInterface {
    private let serviceClient: SearchServiceClientInterface

    init(serviceClient: SearchServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void) {
        serviceClient.search(
            term: term,
            completion: { result in
                let mappedResult: Result<SearchResult, SearchError> = result.flatMap {
                    $0.results.isEmpty ? .failure(.noResults) : .success($0)
                }

                DispatchQueue.main.async {
                    completion(mappedResult)
                }
            }
        )
    }
}

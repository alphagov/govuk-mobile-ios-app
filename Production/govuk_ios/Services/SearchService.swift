import Foundation

protocol SearchServiceInterface {
    func search(_ term: String,
                completion: @escaping (Result<SearchResult, SearchError>) -> Void)

    func suggestions(_ term: String,
                     completion: @escaping ([String]) -> Void)
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

    func suggestions(_ term: String,
                     completion: @escaping ([String]) -> Void) {
        serviceClient.suggestions(
            term: term,
            completion: { result in
                let suggestions = (try? result.get().suggestions) ?? []

                DispatchQueue.main.async {
                    completion(suggestions)
                }
            }
        )
    }
}

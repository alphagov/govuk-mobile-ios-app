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
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        )
    }
}

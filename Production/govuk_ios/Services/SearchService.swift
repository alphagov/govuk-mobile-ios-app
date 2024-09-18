import Foundation

protocol SearchServiceInterface {
    func search(_ term: String,
                completion: @escaping (NetworkResult<SearchResult>) -> Void)
}

class SearchService: SearchServiceInterface {
    private let serviceClient: APIServiceClientInterface

    init(serviceClient: APIServiceClientInterface) {
        self.serviceClient = serviceClient
    }

    func search(_ term: String,
                completion: @escaping (NetworkResult<SearchResult>) -> Void) {
        let searchRequest = GOVRequest(
            urlPath: "/api/search.json",
            method: .get,
            bodyParameters: nil,
            queryParameters: ["q": term, "count": "10"],
            additionalHeaders: nil
        )
        serviceClient.send(
            request: searchRequest,
            completion: { result in
                let mappedResult: NetworkResult<SearchResult>
                switch result {
                case .failure:
                    mappedResult = .failure(SearchError.apiUnavailable)
                case .success(let data):
                    do {
                        let searchResult = try JSONDecoder().decode(
                            SearchResult.self,
                            from: data
                        )
                        mappedResult = .success(searchResult)
                    } catch {
                        mappedResult = .failure(SearchError.apiUnavailable)
                    }
                    DispatchQueue.main.async {
                        completion(mappedResult)
                    }
                }
            }
        )
    }
}

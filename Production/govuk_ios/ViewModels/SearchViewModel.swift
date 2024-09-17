import UIKit

enum SearchErrorState {
    case apiUnavailable, noResults, networkUnavailable
}

class SearchViewModel {
    @Inject(\.govukAPIClient) var govukAPIClient: APIServiceClientInterface

    let analyticsService: AnalyticsServiceInterface
    var searchResults: [SearchItem]?
    var searchErrorState: SearchErrorState?

    init(analyticsService: AnalyticsServiceInterface) {
        self.analyticsService = analyticsService
    }

    func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm)
        )
    }

    func fetchSearchResults(searchText: String, completion: @escaping () -> Void) {
        guard !searchText.isEmpty else { return }

        let searchRequest = GOVRequest(
            urlPath: "/api/search.json",
            method: .get,
            bodyParameters: nil,
            queryParameters: ["q": searchText, "count": "10"],
            additionalHeaders: nil
        )
        govukAPIClient.send(
            request: searchRequest,
            completion: { result in
                switch result {
                case .failure:
                    self.searchResults = []
                    self.searchErrorState = .apiUnavailable

                    return completion()
                case .success:
                    let data = try? result.get()
                    if data == nil {
                        self.searchErrorState = .apiUnavailable
                    }

                    self.searchResults = try? JSONDecoder().decode(
                        SearchResult.self, from: data ?? Data()
                    ).results

                    if self.searchResults?.count == 0 {
                        self.searchErrorState = .noResults
                    }

                    return completion()
                }
            }
        )
    }

    func itemTitle(_ index: Int) -> String {
        (searchResults?[index]
            .title
            .trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
    }

    func itemDescription(_ index: Int) -> String {
        (searchResults?[index]
            .description
            .trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
    }
}

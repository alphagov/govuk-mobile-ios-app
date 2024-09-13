import UIKit

class SearchViewModel {
    @Inject(\.govukAPIClient) private var govukAPIClient: APIServiceClient

    let analyticsService: AnalyticsServiceInterface
    var searchResults: [SearchItem]?

    init(analyticsService: AnalyticsServiceInterface) {
        self.analyticsService = analyticsService
    }

    func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm)
        )
    }

    public func fetchSearchResults(searchText: String, tableView: UITableView) {
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
                guard let data = try? result.get()
                else { return }

                self.searchResults = try? JSONDecoder().decode(
                    SearchResult.self, from: data
                ).results

                tableView.reloadData()
            }
        )
    }
}

struct SearchResult: Decodable {
    var results: [SearchItem]
}

struct SearchItem: Decodable {
    var title: String
    var description: String
    var link: String
}

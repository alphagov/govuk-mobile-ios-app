import UIKit

enum SearchError: Error {
    case apiUnavailable
    case noResults
    case networkUnavailable
    case parsingError
}

class SearchViewModel {
    private let searchService: SearchServiceInterface
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener

    private(set) var results: [SearchItem]?
    private(set) var error: SearchError?

    init(analyticsService: AnalyticsServiceInterface,
         searchService: SearchServiceInterface,
         urlOpener: URLOpener) {
        self.analyticsService = analyticsService
        self.searchService = searchService
        self.urlOpener = urlOpener
    }

    func selected(item: SearchItem) {
        trackSearchItemSelection(item)
        openLink(item: item)
    }

    private func openLink(item: SearchItem) {
        var components = URLComponents(string: item.link)
        let scheme = components?.scheme
        components?.scheme = scheme ?? "https"
        let host = components?.host
        components?.host = host ?? "www.gov.uk"

        guard let url = components?.url
        else { return }
        urlOpener.openIfPossible(url)
    }

    private func trackSearchItemSelection(_ item: SearchItem) {
        analyticsService.track(
            event: AppEvent.searchItem(item: item)
        )
    }

    func search(text: String?,
                completion: @escaping () -> Void) {
        error = nil
        guard let text = text,
              !text.isEmpty
        else { return }

        trackSearchTerm(searchTerm: text)
        searchService.search(
            text,
            completion: { [weak self] result in
                self?.results = try? result.get().results
                self?.error = result.getError()
                completion()
            }
        )
    }

    private func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm)
        )
    }
}

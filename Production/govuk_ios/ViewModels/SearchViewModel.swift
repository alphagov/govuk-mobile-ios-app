import UIKit

enum SearchError: Error {
    case apiUnavailable
    case noResults
    case networkUnavailable
    case parsingError
}

class SearchViewModel {
    private let analyticsService: AnalyticsServiceInterface
    private let searchService: SearchServiceInterface
    private let activityService: ActivityServiceInterface
    private let urlOpener: URLOpener

    private(set) var results: [SearchItem]?
    private(set) var error: SearchError?

    init(analyticsService: AnalyticsServiceInterface,
         searchService: SearchServiceInterface,
         activityService: ActivityServiceInterface,
         urlOpener: URLOpener) {
        self.analyticsService = analyticsService
        self.activityService = activityService
        self.searchService = searchService
        self.urlOpener = urlOpener
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

    func selected(item: SearchItem) {
        activityService.save(searchItem: item)
        trackSearchItemSelection(item)
        urlOpener.openIfPossible(item.link)
    }

    func clearResults() {
        results = []
    }

    private func trackSearchItemSelection(_ item: SearchItem) {
        let event = AppEvent.searchResultNavigation(
            item: item
        )
        analyticsService.track(
            event: event
        )
    }

    private func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm.redactPii())
        )
    }
}

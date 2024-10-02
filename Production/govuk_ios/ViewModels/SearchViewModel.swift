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
    private let activityService: ActivityServiceInterface
    private let urlOpener: URLOpener

    private(set) var results: [SearchItem]?
    private(set) var error: SearchError?

    init(analyticsService: AnalyticsServiceInterface,
         searchService: SearchServiceInterface,
         activityService: ActivityServiceInterface,
         urlOpener: URLOpener) {
        self.analyticsService = analyticsService
        self.searchService = searchService
        self.activityService = activityService
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
        trackSearchItemSelection(item, url: item.link)
        urlOpener.openIfPossible(item.link)
    }

    private func trackSearchItemSelection(_ item: SearchItem, url: URL) {
        analyticsService.track(
            event: AppEvent.searchItemNavigation(
                title: item.title,
                url: url,
                external: true
            )
        )
    }

    private func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm)
        )
    }
}

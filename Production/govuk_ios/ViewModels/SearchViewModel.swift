import UIKit
import GOVKit

enum SearchError: Error {
    case apiUnavailable
    case noResults
    case networkUnavailable
    case parsingError
}

class SearchViewModel {
    let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    private let searchService: SearchServiceInterface
    private let activityService: ActivityServiceInterface
    lazy var searchSuggestionsViewModel: SearchSuggestionsViewModel = {
        SearchSuggestionsViewModel(searchService: searchService,
                                   analyticsService: analyticsService)
    }()
    lazy var searchHistoryViewModel: SearchHistoryViewModel = {
        SearchHistoryViewModel(searchService: searchService,
                               analyticsService: analyticsService)
    }()

    var historyIsEmpty: Bool {
        searchHistoryViewModel.searchHistoryItems.isEmpty
    }

    private(set) var results: [SearchItem]?
    private(set) var error: SearchError?
    private let openAction: (SearchItem) -> Void
    private var redactedSearchTerm: String?

    init(analyticsService: AnalyticsServiceInterface,
         searchService: SearchServiceInterface,
         activityService: ActivityServiceInterface,
         urlOpener: URLOpener,
         openAction: @escaping (SearchItem) -> Void) {
        self.analyticsService = analyticsService
        self.activityService = activityService
        self.searchService = searchService
        self.urlOpener = urlOpener
        self.openAction = openAction
    }

    func search(text: String?,
                type: SearchInvocationType,
                completion: @escaping () -> Void) {
        error = nil
        guard let text = text,
              !text.isEmpty
        else { return }

        let redactor = Redactor.pii
        redactedSearchTerm = redactor.redact(text)
        trackSearchTerm(type: type)
        searchService.search(
            text,
            completion: { [weak self] result in
                self?.results = try? result.get().results
                self?.trackEcommerceSearchResults()
                self?.error = result.getError()
                completion()
            }
        )
        searchHistoryViewModel.saveSearchHistoryItem(searchText: text, date: .init())
    }

    func selected(item: SearchItem) {
        activityService.save(searchItem: item)
        trackSearchItemSelected(item)
        openAction(item)
    }

    func clearResults() {
        results = []
    }

    private func trackSearchItemSelected(_ item: SearchItem) {
        let event = AppEvent.searchResultNavigation(item: item)
        analyticsService.track(event: event)
        trackEcommerceSelectedResult(name: item.title)
    }

    private func trackSearchTerm(type: SearchInvocationType) {
        analyticsService.track(
            event: AppEvent.searchTerm(
                term: redactedSearchTerm ?? "",
                type: type
            )
        )
    }

    private func trackEcommerceSearchResults() {
        guard let results else { return }

        analyticsService.track(
            event: AppEvent.viewItemList(
                name: "Search",
                id: "Search",
                items: ecommerceResults(results)
            )
        )
    }

    private func trackEcommerceSelectedResult(name: String) {
        guard let results else { return }

        analyticsService.track(
            event: AppEvent.selectSearchItem(
                name: name,
                items: ecommerceResults(results)
            )
        )
    }

    private func ecommerceResults(_ results: [SearchItem]) -> [SearchCommerceItem] {
        results.enumerated().map { index, result in
            SearchCommerceItem(
                name: result.title,
                index: index + 1,
                term: redactedSearchTerm ?? "",
                itemLocation: result.link.absoluteString,
                itemId: result.contentId
            )
        }
    }
}

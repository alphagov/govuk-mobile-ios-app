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

        trackSearchTerm(searchTerm: text, type: type)
        searchService.search(
            text,
            completion: { [weak self] result in
                self?.results = try? result.get().results
                self?.error = result.getError()
                completion()
            }
        )
        searchHistoryViewModel.saveSearchHistoryItem(searchText: text, date: .init())
    }

    func selected(item: SearchItem) {
        activityService.save(searchItem: item)
        trackSearchItemSelection(item)
//        urlOpener.openIfPossible(item.link)
        openAction(item)
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

    private func trackSearchTerm(searchTerm: String, type: SearchInvocationType) {
        let redactor = Redactor.pii
        let redactedSearchTerm = redactor.redact(searchTerm)
        analyticsService.track(
            event: AppEvent.searchTerm(
                term: redactedSearchTerm,
                type: type
            )
        )
    }
}

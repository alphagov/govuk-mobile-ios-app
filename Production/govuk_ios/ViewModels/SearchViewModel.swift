import UIKit

enum SearchError: Error {
    case apiUnavailable
    case noResults
    case networkUnavailable
}

class SearchViewModel {
    private let searchService: SearchServiceInterface
    private let analyticsService: AnalyticsServiceInterface

    private(set) var results: [SearchItem]?
    private(set) var error: SearchError?

    init(analyticsService: AnalyticsServiceInterface,
         searchService: SearchServiceInterface) {
        self.analyticsService = analyticsService
        self.searchService = searchService
    }

    func trackSearchItemPress(_ item: SearchItem) {
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
            completion: { result in
                self.results = try? result.get().results
                self.error = result.getError() as? SearchError
                completion()
            }
        )
    }

    private func trackSearchTerm(searchTerm: String) {
        analyticsService.track(
            event: AppEvent.searchTerm(term: searchTerm)
        )
    }

    func itemTitle(_ index: Int) -> String {
        ""
//        (results?[index]
//            .title
//            .trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
    }

    func itemDescription(_ index: Int) -> String {
        ""
//        (results?[index]
//            .description
//            .trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
    }
}

extension Result {
    func getError() -> Failure? {
        if case .failure(let failure) = self {
            return failure
        }
        return nil
    }
}
